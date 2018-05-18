from distutils.core import setup

setup(
    name='imperium',
    version='0.1',
    author='Christopher Iliffe Sprague',
    author_email='christopher.iliffe.sprague@gmail.com',
    url='https://github.com/cisprague/imperium',
    description='A library for neurocontrol of dynamical systems.',
    packages_dir = {'imperium', 'src/imperium'}
)
