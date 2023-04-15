import * as fs from 'fs'

if (process.argv.length !== 3) {
    console.error('Usage: node make-standard-json.js input.yul')
    process.exit(1)
}

const filePath = process.argv[2]
if (!fs.existsSync(filePath)) {
    console.error(`${filePath} not found`)
    process.exit(1)
}

const content = fs.readFileSync(filePath).toString('utf-8')
const standardJson = {
    language: 'Yul',
    sources: { 'input.yul': { content: content } },
    settings: {
        'outputSelection': { '*': { '*': ['*'], '': [ '*' ] } },
        'optimizer': { 'enabled': true, 'details': { 'yul': true } }
    }
}
fs.writeFileSync('input.json', JSON.stringify(standardJson, null, 2))
