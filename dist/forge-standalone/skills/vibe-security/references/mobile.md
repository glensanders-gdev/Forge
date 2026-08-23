# Mobile Security (React Native / Expo)

## No Secrets in the JavaScript Bundle

All API keys and secrets in the JS bundle are extractable — even with Hermes bytecode compilation. The bundle is a file on the device that can be read, decompiled, and string-searched.

- `react-native-config` values are baked in at build time. Not secret.
- `EXPO_PUBLIC_` values are baked in at build time. Not secret.
- Environment variables via `eas.json` or `app.config.js` that end up in the JS bundle are not secret.

**The only safe approach:** use a backend proxy for all third-party API calls that require secret keys.

```typescript
// BAD: API key in the mobile app
const response = await fetch('https://api.openai.com/v1/chat/completions', {
  headers: { 'Authorization': `Bearer ${OPENAI_API_KEY}` }
});

// GOOD: call your own backend, which holds the key
const response = await fetch('https://your-api.com/ai/chat', {
  headers: { 'Authorization': `Bearer ${userSessionToken}` },
  body: JSON.stringify({ message: userInput }),
});
```

## Secure Token Storage

- **Use `expo-secure-store`** (Expo) or **`react-native-keychain`** (bare RN) for auth tokens.
- **Never use `AsyncStorage`** — it's unencrypted plaintext on disk. On a rooted/jailbroken device, tokens are trivially readable.

```typescript
// BAD
await AsyncStorage.setItem('authToken', token);

// GOOD
await SecureStore.setItemAsync('authToken', token);
```

## Deep Link Security

Deep links (`myapp://path?param=value`) can be triggered by any app or website:

- Validate and sanitize all parameters. Never trust deep link input.
- Never include sensitive data in deep link URLs (tokens, passwords, user IDs that grant access).
- Don't perform destructive actions directly from deep link parameters without user confirmation.

## Biometric Authentication

A boolean success check (`isAuthenticated = true`) can be hooked with Frida on a jailbroken device. Proper biometric auth uses cryptographic verification:

1. Server sends a challenge (random nonce)
2. App signs the challenge with a hardware-backed key (Secure Enclave / Strongbox)
3. Server verifies the signature

Even if the biometric check is bypassed, the attacker cannot forge the cryptographic signature.
