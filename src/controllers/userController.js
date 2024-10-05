const UserModel = require('../models/userModel');
const bcryptjs = require('bcryptjs');
const { ethers } = require("ethers");
const eLearningABI = require('../../abi/e-learning');
require('dotenv').config();

const provider = new ethers.JsonRpcProvider(process.env.ETH_NODE_URL);
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
const contractABI = eLearningABI;

const contractAddress = process.env.CONTRACT_ADDRESS;
const contract = new ethers.Contract(contractAddress, contractABI, wallet)

class UserController {
    async registerUser(req, res) {
        const { name, email, role, username, password } = req.body;

        const saltRounds = 10;

        try {
            const existingUser = await UserModel.findUserByEmail(email);
            if (existingUser) {
                return res.status(400).json({ error: 'User already exists' });
            }

            const tx = await contract.registerUser(name, email, role);
            await tx.wait();

            const hashedPassword = await bcryptjs.hash(password, saltRounds);
            const pass = hashedPassword;

            const user = await UserModel.createUser(name, email, role, username, pass);
            const id = user.id; 
            res.status(200).json({ message: 'User registered successfully!',  transactionHash: tx.hash, userId: id});
        } catch (error) {
            console.error(error);
            res.status(500).json({ error: 'Failed to register user' });
        }
    }
}

module.exports = new UserController();