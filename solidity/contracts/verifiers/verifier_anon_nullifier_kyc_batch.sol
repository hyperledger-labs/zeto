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

contract Groth16Verifier_AnonNullifierKycBatch {
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

    
    uint256 constant IC0x = 5903479180487694997279265064344131881874542681454350742852120100073440524296;
    uint256 constant IC0y = 9530657098554586749733666785385875949917582344806050500162894090355413522611;
    
    uint256 constant IC1x = 20973102971231858407268823830547921302985922314772564832818590542439356456221;
    uint256 constant IC1y = 8755463976472172454997983726165070757321336399692622916062903478185835201876;
    
    uint256 constant IC2x = 17526751735834480101264016483328365202855873905596039358244611690496383169381;
    uint256 constant IC2y = 19471421123818568632786393804346662846532826068692835523015112968845449782837;
    
    uint256 constant IC3x = 3539748145202926178617311013596015645546621712094449177218775970412840331990;
    uint256 constant IC3y = 12107775276152948776165489655192329079375808485402641019338912689660992652639;
    
    uint256 constant IC4x = 10736132798369970949317591880421041650057251866854449145769798014056707582400;
    uint256 constant IC4y = 9086693743465940414222843502454124169492399568586435675372053519657938027667;
    
    uint256 constant IC5x = 12425715134565817955257724101559867268846011832217311339913736232262680480585;
    uint256 constant IC5y = 16142750039343766472981827121627520729505164201659292781578940159554138118192;
    
    uint256 constant IC6x = 12006435987609063305657955204304130887359188491414522470083767433434906438697;
    uint256 constant IC6y = 458423307973335590408769742998544169851369310753326352756852767731137356765;
    
    uint256 constant IC7x = 4360502195945359224890359403296421498543274286794431551192530464214184213036;
    uint256 constant IC7y = 6077490470642740655603314453740752926435817176771799958915136065070082008178;
    
    uint256 constant IC8x = 16580344970308070849104104853313158021715014518923556141289343560126714766440;
    uint256 constant IC8y = 1735370040403212368006858236286058201634946457464953807044808823314333576501;
    
    uint256 constant IC9x = 11277842595314006154476847746796065571660929661941608012290181305175139250956;
    uint256 constant IC9y = 14010510022143235230713910523185405080140344333173500379192481888872864784779;
    
    uint256 constant IC10x = 10027027914330943530569092473741094434086563269833520803780904295572828067751;
    uint256 constant IC10y = 421990751027288915733155885330259124989116330315517655643992915427432279442;
    
    uint256 constant IC11x = 599244215281404141046456725437495318313391113948484631072822414812570716776;
    uint256 constant IC11y = 10068255294045654417350386146388876221615727778457099371804026702882247474491;
    
    uint256 constant IC12x = 21556964792859825649107667215781058705147965296731829911281160087820610838533;
    uint256 constant IC12y = 13889886910952233505246502579980063028755614337122208662602852777579996569369;
    
    uint256 constant IC13x = 20336517095597583565227873677117826914448174923218395440417472253759155911879;
    uint256 constant IC13y = 13787294756325562052369133551051867132268321423810906151242602397719118060605;
    
    uint256 constant IC14x = 723470074228247172376833529746853811390760610497044842304414745837297007793;
    uint256 constant IC14y = 20473431670688220490381842545562296561006547604975254617604046916777297966342;
    
    uint256 constant IC15x = 15002382818055737103129754932077118357634513012564080449864984893716211852169;
    uint256 constant IC15y = 20986355934261372161815389867821841925843222171872598595602774389117273842363;
    
    uint256 constant IC16x = 12194141240267141280402887975844644072507435166373817904521349435520239196563;
    uint256 constant IC16y = 14593389642349486216409486354692535004279895256912795030101019816199908203510;
    
    uint256 constant IC17x = 21015394223495022989411464000109008933122362273422924620851048926767533637678;
    uint256 constant IC17y = 19949217149297160174771427449019144865727740578144251352593703549274424714243;
    
    uint256 constant IC18x = 3943681362690863707194051007800503356665352728683045015484432282818996793654;
    uint256 constant IC18y = 5926512517402465313700496622240148434683755798658418845914485987943511193577;
    
    uint256 constant IC19x = 18521510625410973039043143625576116776310762869742273135122587764220766348395;
    uint256 constant IC19y = 7566293396936121921157226464680078121529744119588821801602132955535815373956;
    
    uint256 constant IC20x = 6955777603382581542780895326909850846348823267515133043834193460373252526587;
    uint256 constant IC20y = 5404988211516657994220064031142977435521957627605222735616136075971916277477;
    
    uint256 constant IC21x = 15342762311956869996626100728582941890438868605264297782193785457846632248470;
    uint256 constant IC21y = 20548254230250891011773309995179021079622280572238402743503817964378124498364;
    
    uint256 constant IC22x = 13468425754230748688976754818188805414992261059993406476820218042607689692919;
    uint256 constant IC22y = 19259260110764955907957588951746942381445285741917061612123980235317042412735;
    
    uint256 constant IC23x = 7617190663029341979667377709868897026767966101370820487323419742367227464607;
    uint256 constant IC23y = 5828305386936705254095338960335559624881719900670519001227372129217412593638;
    
    uint256 constant IC24x = 19149413451075061406036034331861834406010553383404615574802306336889836590275;
    uint256 constant IC24y = 9477087352704683947570484182823100219649648425336029593609027362914899796882;
    
    uint256 constant IC25x = 7458849390840810649225684326404357042001194061988724602214310891606424306819;
    uint256 constant IC25y = 10597359029377765811758852800451451553074982025943987922238070581358117884136;
    
    uint256 constant IC26x = 842696973558123879709109182614111148322768473432915344493046542591033681493;
    uint256 constant IC26y = 2781881074750924182130845305550304707733282921294174566559928537889278237955;
    
    uint256 constant IC27x = 15683147951893410406096346361449163187734233904509983293856126129311265101694;
    uint256 constant IC27y = 2168339806599618332193644721673922939969280545067403095587408807381894124936;
    
    uint256 constant IC28x = 315035763854939145651156391340482052373168276614904956736944285000361956025;
    uint256 constant IC28y = 9046029775992129776233430487821134767415535416404106476900939230072605015949;
    
    uint256 constant IC29x = 16702595149630469028030520205968648581925571239778200153461762033026978869996;
    uint256 constant IC29y = 5341264583221686396554877164304749669102173766319974665739654603930076339494;
    
    uint256 constant IC30x = 18227910701337243042149451855343331991113536790424339012387740307180547799123;
    uint256 constant IC30y = 16668301100901313623883556739908219939542169305008917255663502734039639028530;
    
    uint256 constant IC31x = 17932140945438074805410982119641969109381625073969182331989455928253180143871;
    uint256 constant IC31y = 717429811186727663024363834879237912962885409222145707098451744204589841172;
    
    uint256 constant IC32x = 21300530289886932428943247518243862485766592202594141281048932055023624349053;
    uint256 constant IC32y = 13615442376031284726048819111701820235342371039395336046041214770848322742864;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[32] calldata _pubSignals) public view returns (bool) {
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
                
                g1_mulAccC(_pVk, IC32x, IC32y, calldataload(add(pubSignals, 992)))
                

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
            
            checkField(calldataload(add(_pubSignals, 992)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
