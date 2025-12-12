
#!/usr/bin/env bash
mkdir -p ~/.local/share/fonts
wget -O ~/.local/share/fonts/FiraCode.zip \
	https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip

unzip -o ~/.local/share/fonts/FiraCode.zip -d ~/.local/share/fonts
rm ~/.local/share/fonts/FiraCode.zip
fc-cache -fv
