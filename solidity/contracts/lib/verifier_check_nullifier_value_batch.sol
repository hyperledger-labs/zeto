// SPDX-License-Identifier: GPL-3.0
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity >=0.7.0 <0.9.0;

contract Groth16Verifier_CheckNullifierValueBatch {
    // Scalar field size
    uint256 constant r    = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // Base field size
    uint256 constant q   = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

    // Verification Key data
    uint256 constant alphax  = 20491192805390485299153009773594534940189261866228447918068658471970481763042;
    uint256 constant alphay  = 9383485363053290200918347156157836566562967994039712273449902621266178545958;
    uint256 constant betax1  = 4252822878758300859123897981450591353533073413197771768651442665752259397132;
    uint256 constant betax2  = 6375614351688725206403948262868962793625744043794305715222011528459656738731;
    uint256 constant betay1  = 21847035105528745403288232691147584728191162732299865338377159692350059136679;
    uint256 constant betay2  = 10505242626370262277552901082094356697409835680220590971873171140371331206856;
    uint256 constant gammax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant gammax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant gammay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant gammay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 constant deltax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant deltax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant deltay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant deltay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;

    
    uint256 constant IC0x = 15645827380555101758470301630806534541407460558949468184280712030131609063061;
    uint256 constant IC0y = 16550491271816154144388034149107640878691715400344284166430225714906255329282;
    
    uint256 constant IC1x = 6153483344859958434149301923794306045899659014824492062564883405233096082806;
    uint256 constant IC1y = 15778815662361212202343010651437935635918903262380179566413075098354148176909;
    
    uint256 constant IC2x = 18468020817925342275100340728145608977467411656024920219526108015706677819;
    uint256 constant IC2y = 20028271733570389311888880081776622210185993429032585374918937586222421036392;
    
    uint256 constant IC3x = 20691731807704860034373138504333743004410518356501737227733269745094687949588;
    uint256 constant IC3y = 1319264540019786288319232148504987895927634039697112043623844977582622826692;
    
    uint256 constant IC4x = 15142312234362262221912245115693733737728150893521056795442471741551910122053;
    uint256 constant IC4y = 11399404852242987861643240338863635031525507023338898694340719971134303277049;
    
    uint256 constant IC5x = 7629407377066530339698991515098413880229785623199975451819131278759207281512;
    uint256 constant IC5y = 2560695882471994063584031088068261959488191566639496689436322570758140361851;
    
    uint256 constant IC6x = 8496512421149256363711326441346248387384922138272454898401276205118073670069;
    uint256 constant IC6y = 9598382270415521615662546436487090815783386747209319829750334535273139951619;
    
    uint256 constant IC7x = 5926417128358719146299852019235658425613865932253894129280028204789610169034;
    uint256 constant IC7y = 7226601286611624754127481535004061794115892927880976606394553693560424523093;
    
    uint256 constant IC8x = 14253011321059518351090527885468001405762005813969528939154246573802588283399;
    uint256 constant IC8y = 15344631899561233966963077053492014139945242986266350171181220375576883693071;
    
    uint256 constant IC9x = 19405389969121953436442579301648714122407471813037773911405871895714361926306;
    uint256 constant IC9y = 5156350149070001696589062707747381909924470550276248447214593804387444735149;
    
    uint256 constant IC10x = 14706187145650489776715034411092408069039262440333579964078960528824685997273;
    uint256 constant IC10y = 9351723794068506444099480518410596554842892604237039735261990632428424498442;
    
    uint256 constant IC11x = 19580268659452972844085788497211106943600102277626701969016365010145417510051;
    uint256 constant IC11y = 17892259870327851083506471379114348787961013148152914042025748168867607951918;
    
    uint256 constant IC12x = 1368187844258725974571984010357593022197235678125484244830004603397524277131;
    uint256 constant IC12y = 11689770507120473593171882218023027238180858278471059426010066331590214577458;
    
    uint256 constant IC13x = 13287712015073561033909845382650846894849139649514115583937976829273226297697;
    uint256 constant IC13y = 3939430636009527055304021582867525744150816103797934852056979340342893625279;
    
    uint256 constant IC14x = 10783507502130178541889745165122149974956654644695976949110737257245146067992;
    uint256 constant IC14y = 7255125571322345129880897792656244310326628931432725398368506928666720163008;
    
    uint256 constant IC15x = 15371140816776210377837100749546367776777975416661035244674352159022864632172;
    uint256 constant IC15y = 13898775526037620279429837257001020975978126821900304506267468805318602427097;
    
    uint256 constant IC16x = 14426449469879908724779330900691315457884035732957138831637861015391383558876;
    uint256 constant IC16y = 3451171756433536780316813170918271020431332608912271627875806152547283585184;
    
    uint256 constant IC17x = 19803444206798798843904919208676690018525500115869773298952070002303455934201;
    uint256 constant IC17y = 18911444302965650339696108648975621545327334935330378418452331498109810480671;
    
    uint256 constant IC18x = 3008341434953029690045189802621401378237820736221686047893928949753270897956;
    uint256 constant IC18y = 13350855518944994748544339040015123879049547159893360145908889087340298640177;
    
    uint256 constant IC19x = 15900131335610921333626758802905131580301224709204974700316749114807486504053;
    uint256 constant IC19y = 1729318865526374690262520452959657584315619085621871951602181249717700328088;
    
    uint256 constant IC20x = 13845641379291366534634477557244199946623324282300268341071098653725180432075;
    uint256 constant IC20y = 8182608586763810087289077337145591608275544483545503703707793249132806236594;
    
    uint256 constant IC21x = 5343342400303496860861208898492010041508898844862497075734646763773996559494;
    uint256 constant IC21y = 4017382599443690041437974102460647661050512673214397554371763568191322879855;
    
    uint256 constant IC22x = 18257609592466037403188467385684967977123084669893222262201125210461209644509;
    uint256 constant IC22y = 4336704889062162708468189423705402370938020424780356821278034794171415437454;
    
    uint256 constant IC23x = 5631091906436527377164766154509610910409206369818965299775928097487273481563;
    uint256 constant IC23y = 6763857674650635244980241690761230345878997034903998511217286241409348114171;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[23] calldata _pubSignals) public view returns (bool) {
        assembly {
            function checkField(v) {
                if iszero(lt(v, r)) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }
            
            // G1 function to multiply a G1 value(x,y) to value in an address
            function g1_mulAccC(pR, x, y, s) {
                let success
                let mIn := mload(0x40)
                mstore(mIn, x)
                mstore(add(mIn, 32), y)
                mstore(add(mIn, 64), s)

                success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }

                mstore(add(mIn, 64), mload(pR))
                mstore(add(mIn, 96), mload(add(pR, 32)))

                success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function checkPairing(pA, pB, pC, pubSignals, pMem) -> isOk {
                let _pPairing := add(pMem, pPairing)
                let _pVk := add(pMem, pVk)

                mstore(_pVk, IC0x)
                mstore(add(_pVk, 32), IC0y)

                // Compute the linear combination vk_x
                
                g1_mulAccC(_pVk, IC1x, IC1y, calldataload(add(pubSignals, 0)))
                
                g1_mulAccC(_pVk, IC2x, IC2y, calldataload(add(pubSignals, 32)))
                
                g1_mulAccC(_pVk, IC3x, IC3y, calldataload(add(pubSignals, 64)))
                
                g1_mulAccC(_pVk, IC4x, IC4y, calldataload(add(pubSignals, 96)))
                
                g1_mulAccC(_pVk, IC5x, IC5y, calldataload(add(pubSignals, 128)))
                
                g1_mulAccC(_pVk, IC6x, IC6y, calldataload(add(pubSignals, 160)))
                
                g1_mulAccC(_pVk, IC7x, IC7y, calldataload(add(pubSignals, 192)))
                
                g1_mulAccC(_pVk, IC8x, IC8y, calldataload(add(pubSignals, 224)))
                
                g1_mulAccC(_pVk, IC9x, IC9y, calldataload(add(pubSignals, 256)))
                
                g1_mulAccC(_pVk, IC10x, IC10y, calldataload(add(pubSignals, 288)))
                
                g1_mulAccC(_pVk, IC11x, IC11y, calldataload(add(pubSignals, 320)))
                
                g1_mulAccC(_pVk, IC12x, IC12y, calldataload(add(pubSignals, 352)))
                
                g1_mulAccC(_pVk, IC13x, IC13y, calldataload(add(pubSignals, 384)))
                
                g1_mulAccC(_pVk, IC14x, IC14y, calldataload(add(pubSignals, 416)))
                
                g1_mulAccC(_pVk, IC15x, IC15y, calldataload(add(pubSignals, 448)))
                
                g1_mulAccC(_pVk, IC16x, IC16y, calldataload(add(pubSignals, 480)))
                
                g1_mulAccC(_pVk, IC17x, IC17y, calldataload(add(pubSignals, 512)))
                
                g1_mulAccC(_pVk, IC18x, IC18y, calldataload(add(pubSignals, 544)))
                
                g1_mulAccC(_pVk, IC19x, IC19y, calldataload(add(pubSignals, 576)))
                
                g1_mulAccC(_pVk, IC20x, IC20y, calldataload(add(pubSignals, 608)))
                
                g1_mulAccC(_pVk, IC21x, IC21y, calldataload(add(pubSignals, 640)))
                
                g1_mulAccC(_pVk, IC22x, IC22y, calldataload(add(pubSignals, 672)))
                
                g1_mulAccC(_pVk, IC23x, IC23y, calldataload(add(pubSignals, 704)))
                

                // -A
                mstore(_pPairing, calldataload(pA))
                mstore(add(_pPairing, 32), mod(sub(q, calldataload(add(pA, 32))), q))

                // B
                mstore(add(_pPairing, 64), calldataload(pB))
                mstore(add(_pPairing, 96), calldataload(add(pB, 32)))
                mstore(add(_pPairing, 128), calldataload(add(pB, 64)))
                mstore(add(_pPairing, 160), calldataload(add(pB, 96)))

                // alpha1
                mstore(add(_pPairing, 192), alphax)
                mstore(add(_pPairing, 224), alphay)

                // beta2
                mstore(add(_pPairing, 256), betax1)
                mstore(add(_pPairing, 288), betax2)
                mstore(add(_pPairing, 320), betay1)
                mstore(add(_pPairing, 352), betay2)

                // vk_x
                mstore(add(_pPairing, 384), mload(add(pMem, pVk)))
                mstore(add(_pPairing, 416), mload(add(pMem, add(pVk, 32))))


                // gamma2
                mstore(add(_pPairing, 448), gammax1)
                mstore(add(_pPairing, 480), gammax2)
                mstore(add(_pPairing, 512), gammay1)
                mstore(add(_pPairing, 544), gammay2)

                // C
                mstore(add(_pPairing, 576), calldataload(pC))
                mstore(add(_pPairing, 608), calldataload(add(pC, 32)))

                // delta2
                mstore(add(_pPairing, 640), deltax1)
                mstore(add(_pPairing, 672), deltax2)
                mstore(add(_pPairing, 704), deltay1)
                mstore(add(_pPairing, 736), deltay2)


                let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)

                isOk := and(success, mload(_pPairing))
            }

            let pMem := mload(0x40)
            mstore(0x40, add(pMem, pLastMem))

            // Validate that all evaluations ∈ F
            
            checkField(calldataload(add(_pubSignals, 0)))
            
            checkField(calldataload(add(_pubSignals, 32)))
            
            checkField(calldataload(add(_pubSignals, 64)))
            
            checkField(calldataload(add(_pubSignals, 96)))
            
            checkField(calldataload(add(_pubSignals, 128)))
            
            checkField(calldataload(add(_pubSignals, 160)))
            
            checkField(calldataload(add(_pubSignals, 192)))
            
            checkField(calldataload(add(_pubSignals, 224)))
            
            checkField(calldataload(add(_pubSignals, 256)))
            
            checkField(calldataload(add(_pubSignals, 288)))
            
            checkField(calldataload(add(_pubSignals, 320)))
            
            checkField(calldataload(add(_pubSignals, 352)))
            
            checkField(calldataload(add(_pubSignals, 384)))
            
            checkField(calldataload(add(_pubSignals, 416)))
            
            checkField(calldataload(add(_pubSignals, 448)))
            
            checkField(calldataload(add(_pubSignals, 480)))
            
            checkField(calldataload(add(_pubSignals, 512)))
            
            checkField(calldataload(add(_pubSignals, 544)))
            
            checkField(calldataload(add(_pubSignals, 576)))
            
            checkField(calldataload(add(_pubSignals, 608)))
            
            checkField(calldataload(add(_pubSignals, 640)))
            
            checkField(calldataload(add(_pubSignals, 672)))
            
            checkField(calldataload(add(_pubSignals, 704)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
