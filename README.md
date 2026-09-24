# senda_chat

Mock visual del chat de finanzas **Senda**: UI Flutter estilo WhatsApp/glassmorphism, 100 % local. Sirve para prototipar la experiencia del bot (saldo, envío USDC, tarjetas de confirmación) sin backend.

## Qué NO es

- No hay red, API ni WebSocket.
- No firma ni envía transacciones Stellar reales (el “hash” es simulado).
- El adjunto del input es placeholder (no sube archivos).

## Cómo correrlo (Windows)

SDK esperado: `C:\Users\delfi\flutter\bin` (añadilo al PATH de la sesión si hace falta).

```powershell
$env:PATH = "C:\Users\delfi\flutter\bin;$env:PATH"
cd C:\Users\delfi\senda_chat
flutter pub get
flutter run -d windows
# o en navegador:
flutter run -d chrome
```

Mantener limpio: `flutter analyze` y `flutter test` (hay un widget test de la conversación seed).

## Mapa de `lib/`

| Archivo | Rol |
|---|---|
| `main.dart` | App + `Provider` de `ChatController`, tema oscuro, home `ChatScreen`. |
| `screens/chat_screen.dart` | Layout chat (header glass, lista reverse, input). En pantallas >560 px usa marco ~420 px. |
| `state/chat_controller.dart` | Estado mock: seed, envío de texto, confirmar/cancelar acción, respuestas heurísticas. |
| `models/chat_message.dart` | `ChatMessage`, `TextSegment`, `ActionCardData` y enums. |
| `theme/app_theme.dart` | Paleta y `ThemeData` oscuro. |
| `utils/formatters.dart` | USDC formato es (`1.284,50 USDC`), hora/día, parser `**negrita**`, hash falso. |
| `widgets/message_bubble.dart` | Burbuja usuario/bot + cards. |
| `widgets/amount_card.dart` | Tarjeta de saldo USDC. |
| `widgets/action_card.dart` | Confirmar / Cancelar transferencia. |
| `widgets/chat_input_bar.dart` | Campo de texto + enviar. |
| `widgets/rich_message_text.dart` | Render de segmentos bold/normal. |
| `widgets/senda_avatar.dart` | Avatar del bot. |

Dependencias relevantes: `provider`, Material 3. Sin paquetes de red ni Stellar SDK.

## Contrato del estado mock (`ChatController`)

1. **Seed** al arrancar: saludo bot → “¿Cuál es mi saldo?” → tarjeta saldo `1284.50` → pedido envío 25 USDC a Ana Gómez → tarjeta de acción **pending**.
2. **Confirmar**: marca la acción confirmada, inventa un hash corto y responde el bot.
3. **Cancelar**: marca cancelada; aviso de que no se movió USDC.
4. **Texto libre** (`sendUserText`):
   - menciona saldo/balance/“cuánto tengo” → tarjeta saldo fijo `1284.50`;
   - menciona enviar/transfer/pago/USDC → tarjeta de acción (monto y destinatario parseados o defaults `10` / `contacto`);
   - resto → hint de qué puede hacer el bot.

Lista de mensajes: más reciente en índice `0` (`ListView` `reverse: true`).

## Convenciones para seguir

- UI y copy en **español**.
- Mobile-first; en ancho >560 px enmarcar a **~420 px**.
- Montos USDC con **formato es** (`formatUsdc`).
- **No** añadir red/Stellar real salvo pedido explícito.
- Dejar `flutter analyze` limpio y no romper el widget test en `test/widget_test.dart`.

## Identidad visual

Paleta oscura fintech (`AppColors`): fondo `#0B1220`, mint/teal `#5EEAD4`. Burbuja **usuario** verde oscuro `#0F3D2E`, **bot** gris azulado `#1C2538`. Header con blur/glass, badge “Stellar Testnet”, tipografía Segoe UI.
