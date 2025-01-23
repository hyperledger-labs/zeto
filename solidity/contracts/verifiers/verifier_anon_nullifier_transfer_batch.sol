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

contract Groth16Verifier_AnonNullifierTransferBatch {
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

    
    uint256 constant IC0x = 3786337152979887935099922637610732435638740180631820266063400871430402819633;
    uint256 constant IC0y = 9293888847757937224374675180243156496028016761458128254498241806218092283284;
    
    uint256 constant IC1x = 2613326286111734591920494781775404750800304710938135531408987571374322636490;
    uint256 constant IC1y = 15599982638027111785400180927837455989431309291889428933183044772699472077158;
    
    uint256 constant IC2x = 16577993132868602998944296899128487697327667729491435579653477781242342301582;
    uint256 constant IC2y = 2524212847300776057727191915772340752762539183852135800787520910658031375054;
    
    uint256 constant IC3x = 20040887994401253595825133344933456147331129294970552947753411515738441266393;
    uint256 constant IC3y = 13350101555336249413369310159368828948659257425595179694752297203884523137151;
    
    uint256 constant IC4x = 3835897719819172867789687275271946242413422418832560748463432272574383521210;
    uint256 constant IC4y = 15759770002750782637714363472718455211083945324772437470523464501949892900096;
    
    uint256 constant IC5x = 4018858923492592777296344361624050744014513206229118070376542084019846841807;
    uint256 constant IC5y = 5790374511688402166345858094674381813010855323998186248790514067968943857446;
    
    uint256 constant IC6x = 13873559922151226100957867980347509468952249076980605433281127781428766097016;
    uint256 constant IC6y = 17079366533756232245123856175282864564258650838166619492494036173822311699256;
    
    uint256 constant IC7x = 16371447740332693294596939846901724995658056220386213757285155147042238782626;
    uint256 constant IC7y = 8441385500686996976963571708256109269735429647300706716030147768888817742475;
    
    uint256 constant IC8x = 4560522697137283176450890812573836160569409490301477169775874986836663708157;
    uint256 constant IC8y = 449433852899761247480194932861711485558356640416777131258503326999604740449;
    
    uint256 constant IC9x = 7536248152275225891722762972883669170250475859678077224420797876946631906429;
    uint256 constant IC9y = 17980036920981102618285771583381154035490089785743525159141662827387261123876;
    
    uint256 constant IC10x = 6520359164220525265155386274709266517766289259436803139853734621791509514404;
    uint256 constant IC10y = 21368162840781823986174234261008274176487028095574542697455308297011056522636;
    
    uint256 constant IC11x = 11986049124283047338689275016354659993085995403687773059614159878672406545037;
    uint256 constant IC11y = 1720839942816430712816903108884813241869643182010336846593958574729389440480;
    
    uint256 constant IC12x = 12410983687677574157893657225675183803303132301532659422552214052530726469317;
    uint256 constant IC12y = 17824345118891411719771382010799290239467606961339235068922789659663655509754;
    
    uint256 constant IC13x = 19444872974172689434561725816869098654627826005137317657361016988886067248336;
    uint256 constant IC13y = 3172141317144739547875932810700616635313442420128093386048940765681131092361;
    
    uint256 constant IC14x = 6341822874573516725445274172596187511776250848357140465985666938085067778605;
    uint256 constant IC14y = 10990036049763065187228663840382596985383914188335629682023429665320288002265;
    
    uint256 constant IC15x = 3563685232497885739427596637416450424787463707609627934104367359850504982303;
    uint256 constant IC15y = 14523974417703319423058515825317379629896605049279696879645515541999709097899;
    
    uint256 constant IC16x = 10426055994788300403026220351488163197517295733007869321776166355731683467471;
    uint256 constant IC16y = 18175812088634093492623689292236125764292351272021854381676202255919008010343;
    
    uint256 constant IC17x = 3950389660730108543529631996339492738202948080219082719068949318015974186960;
    uint256 constant IC17y = 2727547245375504168114490191114505397213374496025773532049654614435667570690;
    
    uint256 constant IC18x = 8878853611820647211708603584241467289939654374955042014923131062893095601257;
    uint256 constant IC18y = 13640555931452954554478583351999961428703214573943103283873522300398348512261;
    
    uint256 constant IC19x = 19706318980768223269467987992862357090252614480154835271757186053712302707054;
    uint256 constant IC19y = 3550479890941383303746854615447654371345839372883939502972660199314609198224;
    
    uint256 constant IC20x = 13754703141709110513251981557546245368692890422611576710774721290436667971547;
    uint256 constant IC20y = 15622915412029160187321643908593105738313134938831581567824879502136844415106;
    
    uint256 constant IC21x = 12878657066345957537439144048759746489348595042995392127741332409892311328989;
    uint256 constant IC21y = 5634533423081799906181954901378182109129522944123920261387973446573637973526;
    
    uint256 constant IC22x = 1747558549104994006853755338447511580410928014353375959457633482435305339657;
    uint256 constant IC22y = 16693561381938465114233116706143740771384240170854874824494628919950181351869;
    
    uint256 constant IC23x = 1613138279337931031857254936115331776171624220704338069120610390082066380417;
    uint256 constant IC23y = 8417894649949518720347097876791220132985676261354432557373036131639583799446;
    
    uint256 constant IC24x = 15376107650432532562517675238879931109183652385872341741350057207069919760677;
    uint256 constant IC24y = 12163613282894312110952413452590943793689556977608429079525501424245210898987;
    
    uint256 constant IC25x = 21087166981062958259825865347134564875926186819875767696568317823488336917896;
    uint256 constant IC25y = 15762649107811141917603699122632018793639916612208894025714649072338044075586;
    
    uint256 constant IC26x = 5120686049886825058445452951254266343462561773672356770732157430858330491691;
    uint256 constant IC26y = 11046045856891422237147253594749318345951196586790871800156338688334664797048;
    
    uint256 constant IC27x = 11116873825396655991389216659269585145620200225791557320551530972352228098831;
    uint256 constant IC27y = 3271191376177107978938083722391105421120848315078198802353087459617997426104;
    
    uint256 constant IC28x = 21019143498004400903259766749142372667153376608389483897878881810132865116542;
    uint256 constant IC28y = 20058271295969084519220780794685774075235178554301385873847280275673893710867;
    
    uint256 constant IC29x = 3088320503719486244878902559682118797941031906918592703374618231044866477933;
    uint256 constant IC29y = 7957746217390961233365848173642960838604761579306585693479441876449511811100;
    
    uint256 constant IC30x = 9265264187620997738961784598279326190924030246353391735448996655308762594393;
    uint256 constant IC30y = 12870913899766817882209478409287941761615618579244334984219588810560763939529;
    
    uint256 constant IC31x = 5254797586690949845864066912241731823062919857632449946826426119537257133607;
    uint256 constant IC31y = 6442862733198819845417622717002423202646999126954588221448840906596194569308;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[31] calldata _pubSignals) public view returns (bool) {
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
                
                g1_mulAccC(_pVk, IC24x, IC24y, calldataload(add(pubSignals, 736)))
                
                g1_mulAccC(_pVk, IC25x, IC25y, calldataload(add(pubSignals, 768)))
                
                g1_mulAccC(_pVk, IC26x, IC26y, calldataload(add(pubSignals, 800)))
                
                g1_mulAccC(_pVk, IC27x, IC27y, calldataload(add(pubSignals, 832)))
                
                g1_mulAccC(_pVk, IC28x, IC28y, calldataload(add(pubSignals, 864)))
                
                g1_mulAccC(_pVk, IC29x, IC29y, calldataload(add(pubSignals, 896)))
                
                g1_mulAccC(_pVk, IC30x, IC30y, calldataload(add(pubSignals, 928)))
                
                g1_mulAccC(_pVk, IC31x, IC31y, calldataload(add(pubSignals, 960)))
                

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
            
            checkField(calldataload(add(_pubSignals, 736)))
            
            checkField(calldataload(add(_pubSignals, 768)))
            
            checkField(calldataload(add(_pubSignals, 800)))
            
            checkField(calldataload(add(_pubSignals, 832)))
            
            checkField(calldataload(add(_pubSignals, 864)))
            
            checkField(calldataload(add(_pubSignals, 896)))
            
            checkField(calldataload(add(_pubSignals, 928)))
            
            checkField(calldataload(add(_pubSignals, 960)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
