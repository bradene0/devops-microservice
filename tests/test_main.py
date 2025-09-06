from app.main import app

def test_health_route():
    client = app.test_client()
    resp = client.get("/health")
    assert resp.status_code == 200
    assert resp.get_json()["status"] == "ok"

def test_index_route():
    client = app.test_client()
    resp = client.get("/")
    assert resp.status_code == 200
    assert "message" in resp.get_json()
    
    
