from setuptools import setup, find_packages

setup(
  name = "step1a",
  version = "0.1",
  packages = find_packages(),
  entry_points= {
    'console_scripts': [
      'step1a=step1a:main'
    ]
  }
)
