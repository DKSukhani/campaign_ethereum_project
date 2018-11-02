const path = require('path');
const solc = require('solc');
const fs = require('fs-extra');

const buildPath = path.resolve(__dirname, 'build');
fs.removeSync(buildPath);


const campaginPath = path.resolve(__dirname, 'contracts', 'camp.sol');
const source = fs.readFileSync(campaginPath, 'utf8');
const output = solc.compile(source, 1).contracts;
// console.log(output);

fs.ensureDirSync(buildPath);

for (let contract in output) {
    fs.outputJsonSync(
        path.resolve(buildPath, contract.replace(":", "").concat('.json')),
        output[contract]
    );
}






