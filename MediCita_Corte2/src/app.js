require('dotenv').config();const express=require('express'),cors=require('cors'),rateLimit=require('express-rate-limit'),swaggerUi=require('swagger-ui-express'),yaml=require('yamljs');
const {errorHandler}=require('./middlewares/errors');const routes=require('./routes');const app=express();
app.disable('x-powered-by');app.use(cors());app.use(express.json({limit:'128kb'}));
app.use('/api/auth',rateLimit({windowMs:60*1000,limit:30,standardHeaders:'draft-7',legacyHeaders:false}));
app.use('/api-docs',swaggerUi.serve,swaggerUi.setup(yaml.load(require('path').join(__dirname,'../docs/openapi.yaml'))));
app.use('/api',routes);app.use((req,res)=>res.status(404).json({error:'Ruta inexistente'}));app.use(errorHandler);module.exports=app;
