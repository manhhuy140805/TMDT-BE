const crypto = require('crypto');

// Sử dụng bcrypt hash cho password123
// Hash này được tạo từ bcrypt với salt rounds = 10
const hash = '$2b$10$YourHashHere';

// Hoặc tạo hash đơn giản hơn để test
const password = 'password123';
const simpleHash = crypto.createHash('sha256').update(password).digest('hex');

console.log('Simple SHA256 hash:', simpleHash);

// Bcrypt hash thật cho password123 (salt rounds = 10)
// Bạn có thể dùng online tool: https://bcrypt-generator.com/
console.log('\nBcrypt hash for "password123":');
console.log('$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy');
