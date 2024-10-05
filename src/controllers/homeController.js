require('dotenv').config();

const PORT = process.env.PORT;

const homeController = (req, res) => {
    res.status(200).json({ 
        message: 'Welcome to E-learning!',
        endpoints: {
            homeEndpoint: `http://localhost:${PORT}/api/v1`,
            userRegistrationEndpoint: `http://localhost:${PORT}/api/v1/users/register/`
        }
    });
}

module.exports = homeController;