local _={}
_[38]={x=31,id=2,y=0,arrangement=0,type=0}
_[37]={x=22,id=1,y=2,arrangement=6,type=1}
_[36]={x=9,id=0,y=7,arrangement=6,type=1}
_[35]={y=14,x=1,id=0}
_[34]={y=8,x=17,dest=30,id=3}
_[33]={y=8,x=16,dest=30,id=2}
_[32]={y=9,x=17,dest=30,id=1}
_[31]={y=9,x=16,dest=30,id=0}
_[30]={y=14,x=30,target=9,id=3}
_[29]={y=4,x=25,target=7,id=2}
_[28]={y=4,x=7,target=3,id=1}
_[27]={y=13,x=12,target=5,id=0}
_[26]={x=22,w=10,y=11,h=1,style=false,id=15}
_[25]={x=23,w=7,y=3,h=1,style=false,id=14}
_[24]={x=22,w=1,y=3,h=4,style=false,id=13}
_[23]={x=11,w=1,y=2,h=4,style=false,id=12}
_[22]={x=5,w=6,y=2,h=1,style=false,id=11}
_[21]={x=16,w=14,y=7,h=1,style=false,id=10}
_[20]={x=18,w=1,y=14,h=2,style=true,id=9}
_[19]={x=4,w=1,y=2,h=4,style=false,id=8}
_[18]={x=30,w=2,y=7,h=1,style=true,id=7}
_[17]={x=18,w=1,y=8,h=6,style=false,id=6}
_[16]={x=0,w=2,y=8,h=1,style=true,id=5}
_[15]={x=2,w=13,y=8,h=1,style=false,id=4}
_[14]={x=15,w=1,y=0,h=2,style=true,id=3}
_[13]={x=15,w=1,y=2,h=14,style=false,id=2}
_[12]={x=8,w=1,y=11,h=5,style=false,id=1}
_[11]={x=0,w=5,y=12,h=1,style=false,id=0}
_[10]={y=14,x=30,id=3}
_[9]={y=4,x=25,id=2}
_[8]={y=4,x=7,id=1}
_[7]={y=13,x=12,id=0}
_[6]={_[36],_[37],_[38]}
_[5]={_[35]}
_[4]={_[31],_[32],_[33],_[34]}
_[3]={_[27],_[28],_[29],_[30]}
_[2]={_[11],_[12],_[13],_[14],_[15],_[16],_[17],_[18],_[19],_[20],_[21],_[22],_[23],_[24],_[25],_[26]}
_[1]={_[7],_[8],_[9],_[10]}
return {spawners=_[1],walls=_[2],keys=_[3],exits=_[4],starts=_[5],treasures=_[6]}