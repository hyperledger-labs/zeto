pragma circom 2.1.0;

//------------------------------------------------------------------------------
// compute (compile time) the log2 of a number

function FloorLog2(n) {
  return (n==0) ? -1 : (1 + FloorLog2(n>>1));
}

function CeilLog2(n) {
  return (n==0) ? 0 : (1 + FloorLog2(n-1));
}

//------------------------------------------------------------------------------
// decompose an n-bit number into bits

template ToBits(n) {
  signal input  inp;
  signal output out[n];

  var sum = 0;
  for(var i=0; i<n; i++) {
    out[i] <-- (inp >> i) & 1;
    out[i] * (1-out[i]) === 0;
    sum += (1<<i) * out[i];
  }

  inp === sum;
}

//------------------------------------------------------------------------------

template Xor2(n) {
  signal input  inp[2];
  signal output out;
  out <== inp[0] + inp[1] - 2*inp[0]*inp[1];
}

//------------------------------------------------------------------------------
// xor `n` bits together

template XorN(n) {  
  signal input  inp[n];
  signal output out;

  var sum = 0;
  for(var i=0; i<n; i++) {
    sum += inp[i];
  }

  var m = CeilLog2(n+1);
  component tb = ToBits(m);
  tb.inp    <== sum;
  tb.out[0] ==> out;
}

//------------------------------------------------------------------------------
// compute the round constants

// the function rc(t)
function CalcSmallRC(t) {
  var tmod = t % 255;
  if (tmod == 0) {
    return 1;
  }
  else {
    var r = 1;
    for(var i=1; i<=tmod; i++) {
      r  = r << 1;
      var r8 = (r >> 8) & 1;
      r  = r ^ (r8 * 0x71);
      r  = r & 0xff;
    }
    return (r & 1);
  }
}

//--------------------------------------

/*
// circom cannot handle `var rc[w]` ...
function CalcRoundConst(level ,round_idx) {
  var w = (1<<level);
 
  var rc[w];
  for(var i=0; i<w; i++) { rc[i] = 0; }

  for(var j=0; j<=level; j++) {
    rc[ (1<<j) - 1 ] = CalcSmallRC( j + 7*round_idx );
  }
  return rc;
}
*/

//------------------------------------------------------------------------------
// encode/decode state to/from 25 words of size `w`

template EncodeState(level) {
  var w = (1<<level);
  signal input  inp[5][5][w];
  signal output out[25];

  for(var x=0; x<5; x++) {
    for(var y=0; y<5; y++) {
      var sum=0;
      for(var z=0; z<w; z++) {
        sum += inp[x][y][z] * (1<<z);
      }
      out[x+5*y] <== sum;
    }
  }
}

template DecodeState(level) {
  var w = (1<<level);
  signal input  inp[25];
  signal output out[5][5][w];
  component     tb [5][5];

  for(var x=0; x<5; x++) {
    for(var y=0; y<5; y++) {
      tb[x][y] = ToBits(w);
      tb[x][y].inp <== inp[x+5*y];
      tb[x][y].out ==> out[x][y];
    }
  }
}

//------------------------------------------------------------------------------
// linearize state

template LinearizeState(level) {
  var w    = (1<<level);
  var bits = 25*w;
  signal input  inp[5][5][w];
  signal output out[bits];

  for(var x=0; x<5; x++) {
    for(var y=0; y<5; y++) {
      for(var z=0; z<w; z++) {
        out[ w*(5*y+x) + z ] <== inp[x][y][z];
      }
    }
  }
}

template StructureState(level) {
  var w    = (1<<level);
  var bits = 25*w;
  signal input  inp[bits];
  signal output out[5][5][w];

  for(var x=0; x<5; x++) {
    for(var y=0; y<5; y++) {
      for(var z=0; z<w; z++) {
        out[x][y][z] <== inp[ w*(5*y+x) + z ];
      }
    }
  }
}

//------------------------------------------------------------------------------
// THETA

template Theta(level) {
  var w = (1<<level);
  signal input  inp[5][5][w];
  signal output out[5][5][w];

  signal C[5][w];
  signal D[5][w];

  component xor[5][w];

  for(var x=0; x<5; x++) {
    for(var z=0; z<w; z++) {
      xor[x][z] = XorN(5);
      for(var y=0; y<5; y++) { xor[x][z].inp[y] <== inp[x][y][z]; }
      xor[x][z].out ==> C[x][z];
    }
  }

  for(var x=0; x<5; x++) {
    for(var z=0; z<w; z++) {
      var a = C[(x+4)%5][ z       ];
      var b = C[(x+1)%5][(z+w-1)%w];
      D[x][z] <== a + b - 2*a*b;
    }
  }

  for(var x=0; x<5; x++) {
    for(var z=0; z<w; z++) {
      var b = D[x][z];
      for(var y=0; y<5; y++) {
        var a = inp[x][y][z];
        out[x][y][z] <== a + b - 2*a*b;
      }
    }
  }
}

//------------------------------------------------------------------------------
// RHO

template Rho(level) {
  var w = (1<<level);
  signal input  inp[5][5][w];
  signal output out[5][5][w];

  for(var z=0; z<w; z++) { out[0][0][z] <== inp[0][0][z]; }

  var x=1;
  var y=0;
  for(var t=0; t<24; t++) {
    var ofs0 = ((t+1)*(t+2)) \ 2;
    var ofs1 = -ofs0 + (ofs0\w + 1)*w;
    var ofs  = ofs1 % w;

    for(var z=0; z<w; z++) { out[x][y][z] <== inp[x][y][(z+ofs)%w]; }

    var u = (2*x+3*y) % 5;
    x = y;
    y = u;
  }

}

//------------------------------------------------------------------------------
// PI

template Pi(level) {
  var w = (1<<level);
  signal input  inp[5][5][w];
  signal output out[5][5][w];

  for(var x=0; x<5; x++) {
    for(var y=0; y<5; y++) {
      for(var z=0; z<w; z++) {
        out[x][y][z] <== inp[(x+3*y)%5][x][z];
      }
    }
  }
}

//------------------------------------------------------------------------------
// CHI

template Chi(level) {
  var w = (1<<level);
  signal input  inp[5][5][w];
  signal output out[5][5][w];

  signal tmp[5][5][w];

  for(var x=0; x<5; x++) {
    for(var y=0; y<5; y++) {
      for(var z=0; z<w; z++) {
        var a = inp[x      ][y][z];
        var b = inp[(x+1)%5][y][z];
        var c = inp[(x+2)%5][y][z];
        tmp[x][y][z] <== (1-b)*c;
        out[x][y][z] <== a + tmp[x][y][z] - 2*a*tmp[x][y][z];
      }
    }
  }
}

//------------------------------------------------------------------------------
// IOTA

template Iota(level,round_idx) {
  var w = (1<<level);
  signal input  inp[5][5][w];
  signal output out[5][5][w];

  var rc[w];
  for(var i=0; i<w; i++) { 
    rc[i] = 0; 
  }
  for(var j=0; j<=level; j++) {
    rc[ (1<<j) - 1 ] = CalcSmallRC( j + 7*round_idx );
  }

  // var rc_sum = 0;
  // for(var i=0; i<w; i++) {
  //   rc_sum += rc[i] * (1<<i);
  // }
  // log("round #",round_idx," -> RC = ",rc_sum);

  for(var x=0; x<5; x++) {
    for(var y=0; y<5; y++) {
      for(var z=0; z<w; z++) {

        if ( (x==0) && (y==0) ) {
          if (rc[z] != 0) {
            out[x][y][z] <== 1 - inp[x][y][z];
          }
          else {
            out[x][y][z] <== inp[x][y][z];
          }
        }
        else {
          out[x][y][z] <== inp[x][y][z];
        }

      }
    }
  }
}

//------------------------------------------------------------------------------
// a single round

template KeccakStep(level,round_idx) {
  var w = (1<<level);
  signal input  inp[5][5][w];
  signal output out[5][5][w];

  component theta = Theta(level);
  component rho   = Rho  (level);
  component pi    = Pi   (level);
  component chi   = Chi  (level);
  component iota  = Iota (level,round_idx);

  inp       ==> theta.inp;
  theta.out ==> rho.inp;
  rho.out   ==> pi.inp;
  pi.out    ==> chi.inp;
  chi.out   ==> iota.inp;
  iota.out  ==> out;
}

//------------------------------------------------------------------------------
// Keccak-p permutation

template KeccakP(level,nrounds) {
  var w = (1<<level);
  signal input  inp[5][5][w];
  signal output out[5][5][w];

  signal state[nrounds+1][5][5][w];  

  component steps[nrounds];

  state[0] <== inp;

  for(var r=0; r<nrounds; r++) {
    steps[r] = KeccakStep(level, r);
    steps[r].inp <== state[r  ];
    steps[r].out ==> state[r+1];
  }

  state[nrounds] ==> out;
}

//------------------------------------------------------------------------------
// Keccak-f permutation

template KeccakF(level) {
  var w = (1<<level);
  signal input  inp[5][5][w];
  signal output out[5][5][w];

  var nrounds = 12 + 2*level;
  
  component keccak = KeccakP(level,nrounds);
  keccak.inp <== inp;
  keccak.out ==> out;
}

template LinearizedKeccakF(level) {
  var w    = (1<<level);
  var bits = 25*w;
  signal input  inp[bits];
  signal output out[bits];

  component dec = StructureState(level);
  component enc = LinearizeState(level);
  component kec = KeccakF(level);

  inp     ==> dec.inp;
  dec.out ==> kec.inp;
  kec.out ==> enc.inp;
  enc.out ==> out;
}