from unittest import TestCase
from unittest.mock import patch, MagicMock
from src.main import main as main_function


class TestMain(TestCase):
    @patch("builtins.print")
    def test_main(self, mock_print: MagicMock):
        main_function()
        mock_print.assert_called_with("Hello from python-starter-kit!")
