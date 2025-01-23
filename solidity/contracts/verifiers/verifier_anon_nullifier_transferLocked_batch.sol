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

contract Groth16Verifier_AnonNullifierTransferLockedBatch {
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
    
    uint256 constant IC11x = 9974538132428964680219204591139933257236363924840101653935271972025657767035;
    uint256 constant IC11y = 4942469904659636402971335966795132675974922448166612942908890857874246613246;
    
    uint256 constant IC12x = 1449700610141036564231349956718990092923668589008914901255304492978196689411;
    uint256 constant IC12y = 15022060421169999219261094873407391413187459047232642989914901915082306892036;
    
    uint256 constant IC13x = 1553718823578846863111628794399930584656979357695381490925822683578791895008;
    uint256 constant IC13y = 13719144689314028957988248720514401557625557549852410301331966007612091216915;
    
    uint256 constant IC14x = 6705594505209444155372715803820945347690194941093503206540880610013875875152;
    uint256 constant IC14y = 10017801547150225219488615760046841410176688469239363475488139127286632544762;
    
    uint256 constant IC15x = 6880791122402255666598716263003268916723566227940886939621652922030648061222;
    uint256 constant IC15y = 2636893401291241013062181210979823743095889410755235149021483922077913688463;
    
    uint256 constant IC16x = 19545059651177765733278803055255344416170843816921142707027932281153522623851;
    uint256 constant IC16y = 15172758788044894126846176257997140587449407246760231841406910366980031843195;
    
    uint256 constant IC17x = 1077581862741804731983328788596463622247191989724927526432613776956695339272;
    uint256 constant IC17y = 1362550943158643487364517986996732587803463074680706188753903911108498258846;
    
    uint256 constant IC18x = 6685077937639898950226642807719129122483195172282088610880443845250449665037;
    uint256 constant IC18y = 3747041236823858970509703759100789823181986619751354260719642170432031511022;
    
    uint256 constant IC19x = 16815711356835759438370522493804133313410851024172124501659493146338866798172;
    uint256 constant IC19y = 6464876295181192433903608462208098881328050814746877985045172119298429148467;
    
    uint256 constant IC20x = 14108968078114507429481466363166013759548242107691073304229197538001791283289;
    uint256 constant IC20y = 979666287692658704478319788694308922921381414088434420655687977685704964307;
    
    uint256 constant IC21x = 12022447094466995705155930553795245117734392470403323110011678510000706082830;
    uint256 constant IC21y = 10128031196469927983642781782111493931401931734018649631940982559057123865420;
    
    uint256 constant IC22x = 10680008203420642362537419690619967612853008979492550760309901699402005802011;
    uint256 constant IC22y = 17516220209359176184060490144452446805928785496692380488879083318355842725734;
    
    uint256 constant IC23x = 19600126252778916941342697745622255626721374716330173050633429811774995297020;
    uint256 constant IC23y = 7817176476902676935597895059663061974999654210359837422993482290726050596109;
    
    uint256 constant IC24x = 20670411244417205987651144890287238823252044859766116589587849319659930576020;
    uint256 constant IC24y = 4133276491960118982196377463391048567116402878359260589715337179475103012953;
    
    uint256 constant IC25x = 11873290396192685137835013415574323047485764280626338216565341679755551025860;
    uint256 constant IC25y = 12967339602191673077436085385721921209420258192841305076699707516014384891833;
    
    uint256 constant IC26x = 8722562645683043684977525210303435818794730683804614126410526744555789445691;
    uint256 constant IC26y = 3733335959922112826231816476983551582911689623355018255538518487929075955324;
    
    uint256 constant IC27x = 21128822465289532888178996194120275157455110348172748700223877051653750010740;
    uint256 constant IC27y = 2522087472804230196974530239605528740445508102391810098239899467574390210268;
    
    uint256 constant IC28x = 10679332869035673522095223301016276628874210520432573383790817618596612840791;
    uint256 constant IC28y = 21289476335671209652697757092889181257920390864749735231142693162452929062588;
    
    uint256 constant IC29x = 2609832430615706693504774538081221002572019913967502150235593169909827843502;
    uint256 constant IC29y = 14714825072402253083785438274492932618889111283178959924082647535447630873645;
    
    uint256 constant IC30x = 20929918164496425339272582728245933792174244792045067160369780562856539364887;
    uint256 constant IC30y = 21829219789149398038858444958354547306990203732219354012225836377080727840073;
    
    uint256 constant IC31x = 11468462742517897163877881619962635757099976261156385873481574589621371244378;
    uint256 constant IC31y = 8851282702481151749086812126053513960512762416431420501529059283345919393681;
    
    uint256 constant IC32x = 16597903527154606469004098702646630646876098326443455720293607746691316479676;
    uint256 constant IC32y = 6865378811596695553676917046222081530105365855806005223865134455501995569693;
    
 
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
