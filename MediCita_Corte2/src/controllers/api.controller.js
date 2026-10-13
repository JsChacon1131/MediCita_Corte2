const S=require('../services/api.service');
const {wrap}=require('../middlewares/errors');
const ok=(fn,status=200)=>wrap(async(req,res)=>res.status(status).json(await fn(req)));
module.exports={ok,S};
