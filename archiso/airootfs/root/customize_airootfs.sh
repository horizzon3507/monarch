#!/usr/bin/env bash
# Runs inside the airootfs chroot during mkarchiso.
set -e -u

# Locale
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/^#pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf

# Timezone default (install can change it)
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Hostname
echo 'monarch' > /etc/hostname

# Services
systemctl enable NetworkManager
systemctl set-default multi-user.target

# Live user: autologin on tty1, straight into Hyprland
useradd -m -G wheel,audio,video,network -s /bin/zsh live
echo 'live:live' | chpasswd
echo 'root:root' | chpasswd
mkdir -p /etc/systemd/system/getty@tty1.service.d
cat > /etc/systemd/system/getty@tty1.service.d/autologin.conf <<'EOF'
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin live %I $TERM
EOF

# Start Hyprland on tty1 login
cat >> /home/live/.zprofile <<'EOF'
if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = "1" ]; then
    exec Hyprland
fi
EOF

# Passwordless sudo for the live session
mkdir -p /etc/sudoers.d
echo 'live ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/90-live
chmod 440 /etc/sudoers.d/90-live

# Remove cloud-init leftovers if any and set keymap
echo 'KEYMAP=us' > /etc/vconsole.conf
