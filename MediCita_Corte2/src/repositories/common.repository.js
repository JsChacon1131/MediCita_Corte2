const pool=require('../config/db');
const all=async(sql,args=[])=>{const [rows]=await pool.query(sql,args);return rows;};
const one=async(sql,args=[])=>{const rows=await all(sql,args);return rows[0]||null;};
const run=async(sql,args=[])=>{const [result]=await pool.query(sql,args);return result;};
module.exports={pool,all,one,run};
