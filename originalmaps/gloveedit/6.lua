local _={}
_[38]={x=20,id=2,y=6,arrangement=3,type=3}
_[37]={x=20,id=1,y=15,arrangement=0,type=4}
_[36]={x=8,id=0,y=7,arrangement=0,type=4}
_[35]={y=1,x=1,id=0}
_[34]={y=15,x=11,dest=7,id=3}
_[33]={y=15,x=11,dest=7,id=2}
_[32]={y=15,x=11,dest=7,id=1}
_[31]={y=15,x=11,dest=7,id=0}
_[30]={y=15,x=23,target=9,id=3}
_[29]={y=7,x=23,target=1,id=2}
_[28]={y=7,x=11,target=0,id=1}
_[27]={y=15,x=31,target=5,id=0}
_[26]={x=29,w=1,y=7,h=3,style=false,id=15}
_[25]={x=24,w=1,y=12,h=4,style=false,id=14}
_[24]={x=19,w=1,y=12,h=4,style=false,id=13}
_[23]={x=12,w=1,y=12,h=4,style=false,id=12}
_[22]={x=2,w=1,y=7,h=3,style=false,id=11}
_[21]={x=7,w=1,y=12,h=4,style=false,id=10}
_[20]={x=8,w=4,y=12,h=1,style=true,id=9}
_[19]={x=24,w=1,y=3,h=6,style=false,id=8}
_[18]={x=20,w=4,y=8,h=1,style=false,id=7}
_[17]={x=19,w=1,y=3,h=6,style=false,id=6}
_[16]={x=20,w=4,y=3,h=1,style=true,id=5}
_[15]={x=12,w=1,y=3,h=6,style=false,id=4}
_[14]={x=7,w=5,y=8,h=1,style=false,id=3}
_[13]={x=7,w=1,y=3,h=5,style=false,id=2}
_[12]={x=8,w=4,y=3,h=1,style=true,id=1}
_[11]={x=20,w=4,y=12,h=1,style=true,id=0}
_[10]={y=5,x=9,id=3}
_[9]={y=8,x=30,id=2}
_[8]={y=8,x=1,id=1}
_[7]={y=14,x=22,id=0}
_[6]={_[36],_[37],_[38]}
_[5]={_[35]}
_[4]={_[31],_[32],_[33],_[34]}
_[3]={_[27],_[28],_[29],_[30]}
_[2]={_[11],_[12],_[13],_[14],_[15],_[16],_[17],_[18],_[19],_[20],_[21],_[22],_[23],_[24],_[25],_[26]}
_[1]={_[7],_[8],_[9],_[10]}
return {spawners=_[1],walls=_[2],keys=_[3],exits=_[4],starts=_[5],treasures=_[6]}