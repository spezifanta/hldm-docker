function generateRandomPassword(length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let result = '';
    for (let i = 0; i < length; i++) {
        result += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return result;
}

// Generate random rcon password on page load
document.addEventListener('DOMContentLoaded', function() {
    const rconElement = document.getElementById('rcon-password');
    if (rconElement) {
        rconElement.textContent = generateRandomPassword(16);
    }
});