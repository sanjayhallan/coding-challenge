import unittest
from app import hello_world

class SimpleTest(unittest.TestCase):

    def test_hello_world(self):
        self.assertEqual(hello_world(), 'Hello, World!', "Should return 'Hello, World!")


if __name__ == "__main__":
    unittest.main()