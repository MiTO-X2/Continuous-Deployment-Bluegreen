import json, os, subprocess, time, unittest, urllib.request

APP_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

class AppTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.proc = subprocess.Popen(["python3", "app.py", "5099"], cwd=APP_DIR)
        time.sleep(1)

    @classmethod
    def tearDownClass(cls):
        cls.proc.terminate()

    def get(self, path):
        return urllib.request.urlopen("http://127.0.0.1:5099" + path, timeout=5)

    def test_health_ok(self):
        self.assertEqual(json.load(self.get("/health"))["status"], "ok")

    def test_version_matches_repo_file(self):
        v = open(os.path.join(APP_DIR, "VERSION")).read().strip()
        self.assertEqual(json.load(self.get("/version"))["version"], v)

    def test_homepage_renders(self):
        self.assertIn("Demo Shop", self.get("/").read().decode())

if __name__ == "__main__":
    unittest.main()