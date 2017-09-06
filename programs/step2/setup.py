from setuptools import setup, find_packages

setup(
  name = "step2",
  version = "0.1",
  packages = find_packages(),
  entry_points= {
    'console_scripts': [
      'step2=step2:main'
    ]
  }
)
