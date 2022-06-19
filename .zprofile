# Add GOPATH
export GOPATH="$HOME/go"

# Add paths from go/rust/pip
export path=("$GOPATH/bin" "/usr/local/go/bin" "$HOME/.cargo/bin" "$HOME/.local/bin" $path)

# Fix for Arduino IDE tiling
export _JAVA_AWT_WM_NONREPARENTING=1

# Dark mode for calibre
export CALIBRE_USE_DARK_PALETTE=1

# PICO DEV
export PICO_SDK_PATH="$HOME/Documents/gitHub/pico-sdk"
export PICO_EXTRAS_PATH="$HOME/Documents/gitHub/pico-examples"
