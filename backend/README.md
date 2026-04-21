# Smart Finance Tracker Backend

## Run locally

1. Open a terminal in `backend/`
2. Run `npm start`

The API runs on `http://localhost:5000`

## Endpoints

- `POST /register`
- `POST /login`
- `POST /add`
- `GET /expenses`
- `DELETE /expense/:id`
- `GET /health`

## Example requests

Register:

```bash
curl -X POST http://localhost:5000/register ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"demo\",\"password\":\"demo123\"}"
```

Login:

```bash
curl -X POST http://localhost:5000/login ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"demo\",\"password\":\"demo123\"}"
```

Add expense:

```bash
curl -X POST http://localhost:5000/add ^
  -H "Content-Type: application/json" ^
  -H "Authorization: Bearer YOUR_JWT_TOKEN" ^
  -d "{\"amount\":250,\"category\":\"Food\"}"
```
