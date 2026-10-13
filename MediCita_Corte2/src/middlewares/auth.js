const jwt=require('jsonwebtoken');const {HttpError}=require('./errors');
function authenticate(req,res,next){const h=req.headers.authorization||'';const token=h.startsWith('Bearer ')?h.slice(7):'';try{if(!token)throw Error();req.user=jwt.verify(token,process.env.JWT_SECRET,{algorithms:['HS256']});next();}catch{next(new HttpError(401,'Autenticación requerida o token inválido'));}}
function roles(...allowed){return (req,res,next)=>allowed.includes(req.user?.rol)?next():next(new HttpError(403,'No autorizado'))}
module.exports={authenticate,roles};
