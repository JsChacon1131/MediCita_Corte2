class HttpError extends Error {constructor(status,message){super(message);this.status=status;}}
const bad=(msg)=>{throw new HttpError(400,msg)};
const required=(o,fields)=>{for(const f of fields) if(o[f]===undefined||o[f]===null||o[f]==='') bad('Campo requerido: '+f);};
const positiveId=(value)=>{const n=Number(value);if(!Number.isSafeInteger(n)||n<=0)bad('Identificador inválido');return n;};
const wrap=fn=>(req,res,next)=>Promise.resolve(fn(req,res)).catch(next);
function errorHandler(err,req,res,next){if(err.code==='ER_DUP_ENTRY')return res.status(409).json({error:'Duplicado: registro existente'});if(err.code==='ER_NO_REFERENCED_ROW_2')return res.status(400).json({error:'Referencia inexistente'});if(err.code==='ER_ROW_IS_REFERENCED_2')return res.status(409).json({error:'Registro referenciado; no se puede eliminar'});if(err.code==='ER_CHECK_CONSTRAINT_VIOLATED')return res.status(400).json({error:'Restricción de datos no satisfecha'});if(err.status)return res.status(err.status).json({error:err.message});console.error(err);return res.status(500).json({error:'Error interno del servidor'});}
module.exports={HttpError,bad,required,positiveId,wrap,errorHandler};
