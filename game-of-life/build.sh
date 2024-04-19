wasm-pack build
rm -rf www
npm init wasm-app www
cp assets/* www
cd www
#npm install
rm package-lock.json
npm install
npm audit fix
cd ..

