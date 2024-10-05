const knex = require('knex')(require('../../knexfile').development);

class UserModel {
    async createUser(address,name, email, role, username, password) {
        return await knex('users').insert({ name, email, role, username, password });
    }

    async findUserByEmail(email) {
        return await knex('users').where({ email }).first();
    }
}

module.exports = new UserModel();