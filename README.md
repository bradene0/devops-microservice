# A CI/CD Demo App

Simple Flask API with Two endpoints

- `GET /` - Hello Message
- `GET /health` - Checks health

## Run Locally

```bash
pip install -r requirements.txt
python -m app.main
```

## Test
```bash
pytest
```

## Docker Run
```bash
docker build -t my-app .
docker run -p 5000:5000 my-app
```
