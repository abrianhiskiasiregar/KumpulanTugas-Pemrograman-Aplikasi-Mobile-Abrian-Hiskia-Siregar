const express = require('express');
const app = express();
const port = 3000;

// Middleware JSON
app.use(express.json());

// Data produk sementara
let products = [
    {
        id: 1,
        name: 'Laptop',
        price: 10000000
    },
    {
        id: 2,
        name: 'Mouse',
        price: 200000
    }
];

// Route utama
app.get('/', (req, res) => {
    res.send('Server API Berjalan');
});

// ======================
// GET ALL PRODUCTS
// ======================
app.get('/products', (req, res) => {
    res.json(products);
});

// ======================
// GET PRODUCT BY ID
// ======================
app.get('/products/:id', (req, res) => {

    const id = parseInt(req.params.id);

    const product = products.find(p => p.id === id);

    if (!product) {
        return res.status(404).json({
            message: 'Data tidak ditemukan'
        });
    }

    res.json(product);
});

// ======================
// POST PRODUCT
// ======================
app.post('/products', (req, res) => {

    const newProduct = {
        id: products.length + 1,
        name: req.body.name,
        price: req.body.price
    };

    products.push(newProduct);

    res.status(201).json({
        message: 'Data berhasil ditambahkan',
        data: newProduct
    });
});

// ======================
// PUT PRODUCT
// ======================
app.put('/products/:id', (req, res) => {

    const id = parseInt(req.params.id);

    const product = products.find(p => p.id === id);

    if (!product) {
        return res.status(404).json({
            message: 'Data tidak ditemukan'
        });
    }

    product.name = req.body.name;
    product.price = req.body.price;

    res.json({
        message: 'Data berhasil diupdate',
        data: product
    });
});

// ======================
// DELETE PRODUCT
// ======================
app.delete('/products/:id', (req, res) => {

    const id = parseInt(req.params.id);

    const product = products.find(p => p.id === id);

    if (!product) {
        return res.status(404).json({
            message: 'Data tidak ditemukan'
        });
    }

    products = products.filter(p => p.id !== id);

    res.json({
        message: 'Data berhasil dihapus'
    });
});

// Menjalankan server
app.listen(port, () => {
    console.log(`Server berjalan di port ${port}`);
});