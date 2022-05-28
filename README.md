# Oengus documentation
Served at https://docs.oengus.io/

# Development

```sh
# Either use this
npx @redocly/openapi-cli preview-docs http://localhost:8080/v3/api-docs -p 8000
# Or do this instead and use your own http server
npm -g install redoc-cli
redoc-cli build http://localhost:8080/v3/api-docs -t template.hbs
```
