import { createLocalJWKSet, exportJWK, generateKeyPair, SignJWT } from 'jose';
import { beforeEach, describe, expect, it } from 'vitest';
import { verifyAccessJwt } from '../src/middleware/accessAuth';
import { api, seedUsers, U } from './helpers';

const PROD = 'https://qms.medicaltrend.stream';
const ACCESS = { ACCESS_TEAM_DOMAIN: 'https://test.cloudflareaccess.com', ACCESS_AUD: 'test-aud' };

beforeEach(seedUsers);

describe('accessAuth', () => {
  it('rejects requests without Access JWT on the real domain, even when DEV_AUTH_EMAIL is set', async () => {
    const res = await api('/me', { host: PROD, as: U.qm });
    expect(res.status).toBe(401);
  });

  it('rejects a forged JWT on the real domain', async () => {
    const res = await api('/me', { host: PROD, headers: { 'Cf-Access-Jwt-Assertion': 'a.b.c' } });
    expect(res.status).toBe(401);
  });

  it('returns 403 for an email not registered in users', async () => {
    const res = await api('/me', { as: U.nobody });
    expect(res.status).toBe(403);
    expect(await res.json()).toMatchObject({ error: 'user_not_registered' });
  });

  it('returns 403 when the only role has expired (EXT_AUDITOR valid_until)', async () => {
    const res = await api('/me', { as: U.extExpired });
    expect(res.status).toBe(403);
  });

  it('returns the current user with roles', async () => {
    const res = await api('/me', { as: U.staffBsr });
    expect(res.status).toBe(200);
    const body = await res.json<{ user: { roles: unknown[] } }>();
    expect(body.user.roles).toEqual([{ role: 'STAFF', branch_id: 'br-BSR' }]);
  });
});

describe('verifyAccessJwt', () => {
  async function setup() {
    const { publicKey, privateKey } = await generateKeyPair('RS256');
    const jwk = { ...(await exportJWK(publicKey)), kid: 'k1', alg: 'RS256' };
    const jwks = createLocalJWKSet({ keys: [jwk] });
    const sign = (claims: Record<string, unknown>, aud = ACCESS.ACCESS_AUD, iss = ACCESS.ACCESS_TEAM_DOMAIN) =>
      new SignJWT(claims).setProtectedHeader({ alg: 'RS256', kid: 'k1' }).setIssuer(iss).setAudience(aud).setExpirationTime('5m').sign(privateKey);
    return { jwks, sign };
  }

  it('accepts a token with the right issuer and AUD and lower-cases the email', async () => {
    const { jwks, sign } = await setup();
    expect(await verifyAccessJwt(await sign({ email: 'QM@Example.Test' }), ACCESS, jwks)).toBe('qm@example.test');
  });

  it('rejects a token issued for another Access application (AUD)', async () => {
    const { jwks, sign } = await setup();
    await expect(verifyAccessJwt(await sign({ email: 'a@b.c' }, 'other-aud'), ACCESS, jwks)).rejects.toThrow();
  });

  it('rejects a token from another team domain', async () => {
    const { jwks, sign } = await setup();
    await expect(verifyAccessJwt(await sign({ email: 'a@b.c' }, ACCESS.ACCESS_AUD, 'https://evil.cloudflareaccess.com'), ACCESS, jwks)).rejects.toThrow();
  });
});
