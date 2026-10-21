import type { MiddlewareHandler } from 'hono';
import { createRemoteJWKSet, jwtVerify, type JWTVerifyGetKey } from 'jose';
import type { AppEnv, Env } from '../types';

const jwksCache = new Map<string, JWTVerifyGetKey>();

function remoteJwks(teamDomain: string): JWTVerifyGetKey {
  let jwks = jwksCache.get(teamDomain);
  if (!jwks) {
    jwks = createRemoteJWKSet(new URL(`${teamDomain}/cdn-cgi/access/certs`));
    jwksCache.set(teamDomain, jwks);
  }
  return jwks;
}

/** ตรวจ JWT ของ Cloudflare Access กับ team domain + AUD tag แล้วคืนอีเมล (ตัวพิมพ์เล็ก) */
export async function verifyAccessJwt(token: string, env: Pick<Env, 'ACCESS_TEAM_DOMAIN' | 'ACCESS_AUD'>, jwks?: JWTVerifyGetKey) {
  const { payload } = await jwtVerify(token, jwks ?? remoteJwks(env.ACCESS_TEAM_DOMAIN), {
    issuer: env.ACCESS_TEAM_DOMAIN,
    audience: env.ACCESS_AUD,
  });
  if (typeof payload.email !== 'string' || !payload.email) throw new Error('token has no email');
  return payload.email.toLowerCase();
}

const LOCAL_HOSTS = new Set(['localhost', '127.0.0.1', '[::1]']);

/**
 * ตรวจ `Cf-Access-Jwt-Assertion` ทุก request แม้มี Access อยู่หน้าประตู (CLAUDE.md ข้อ 9)
 * ข้อยกเว้นเดียว: DEV_AUTH_EMAIL (มีเฉพาะใน .dev.vars) + request มาจาก localhost
 */
export const accessAuth: MiddlewareHandler<AppEnv> = async (c, next) => {
  const env = c.env;
  const host = new URL(c.req.url).hostname;
  if (env.DEV_AUTH_EMAIL && LOCAL_HOSTS.has(host)) {
    c.set('email', (c.req.header('x-dev-user-email') ?? env.DEV_AUTH_EMAIL).toLowerCase());
    return next();
  }
  const token = c.req.header('Cf-Access-Jwt-Assertion');
  if (!token) return c.json({ error: 'unauthorized' }, 401);
  if (!env.ACCESS_AUD || !env.ACCESS_TEAM_DOMAIN || env.ACCESS_TEAM_DOMAIN.includes('<team>')) {
    console.error('Access is not configured (ACCESS_AUD / ACCESS_TEAM_DOMAIN)');
    return c.json({ error: 'auth_not_configured' }, 500);
  }
  try {
    c.set('email', await verifyAccessJwt(token, env));
  } catch {
    return c.json({ error: 'unauthorized' }, 401);
  }
  await next();
};
