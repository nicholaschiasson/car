#!/usr/bin/env sh

echo "Downloading car and intalling into /usr/local/bin/"
sudo curl -sSf https://raw.githubusercontent.com/nicholaschiasson/car/master/src/car.sh -o /usr/local/bin/car || (>&2 echo "Download failed." && exit 1)
sudo chmod ugo+x /usr/local/bin/car || (>&2 echo "Installation failed." && exit 1)
echo "Installation complete!"
