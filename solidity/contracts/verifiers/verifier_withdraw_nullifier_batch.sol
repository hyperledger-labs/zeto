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

contract Groth16Verifier_WithdrawNullifierBatch {
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

    
    uint256 constant IC0x = 17366683354852295992407143995504174653074195591417819551747878918252419851555;
    uint256 constant IC0y = 19483006769124497327131823516486718544957590921235503972246996412536778649980;
    
    uint256 constant IC1x = 10366104846534137715500591309814118886022119944596398433735317084138833334792;
    uint256 constant IC1y = 18643499405451183547036528756385786304465469271907167766660424194164058707394;
    
    uint256 constant IC2x = 21527677578578888285885541980444416714072945316839881166233809028918267698233;
    uint256 constant IC2y = 6063324619444599539166268744543898744271662754151538561975809930969069774378;
    
    uint256 constant IC3x = 5659430035828023753430174422783281723178462397264403842527625530517452189999;
    uint256 constant IC3y = 2524917828174102567027356560699115590340023663960388221257861988015650700591;
    
    uint256 constant IC4x = 7238189621429832667411485007166185860893028785898240074557092538061430786966;
    uint256 constant IC4y = 20390153919215256777155824947030000580196832273416110104565624202061427202468;
    
    uint256 constant IC5x = 15894469854222667910812295936601612004318640816386618401404798091678758027724;
    uint256 constant IC5y = 14356168113450460554678860751069980826494953509135368818216408384111747891420;
    
    uint256 constant IC6x = 3942663716298823998869531263141686282324249719050386829948592397432348708056;
    uint256 constant IC6y = 3035466022559911517709445948547486025175916218731187151424634579526798275616;
    
    uint256 constant IC7x = 1553309902541816224998744612658270612542776491552112107717121674403292493359;
    uint256 constant IC7y = 11180635816568547989345458896877617901909650248852843301038895683628956771263;
    
    uint256 constant IC8x = 3701018914736177770292204885016878725979532325238333503986400101377864703276;
    uint256 constant IC8y = 19833990420531737080526472786919541772537650521778260464568233706284118513049;
    
    uint256 constant IC9x = 12025524461625658475137301154601859231184602771266597356005073433551998537077;
    uint256 constant IC9y = 1456393002982685462391054585518332799475085362766843390052131361397104224000;
    
    uint256 constant IC10x = 16807793107311666302190473961042321317453287634331068595488371659019485509298;
    uint256 constant IC10y = 18660554898013959088019910686200094855986079232329695676414858332384484100222;
    
    uint256 constant IC11x = 9789863392723531300259587179323466696537747572630489833683814294587664776868;
    uint256 constant IC11y = 4021843822169944439345128570575352294119541799048090956488246619674844965472;
    
    uint256 constant IC12x = 10214507374407129083284926029820451365753765776330479881523358522180753325104;
    uint256 constant IC12y = 6174874849309167082617299735152158687361915126002906606614371830494266455367;
    
    uint256 constant IC13x = 10940606823101131233309979818887945079384613067709355569336590477206410424368;
    uint256 constant IC13y = 1529208575010684508442716482754348867936757320711258330891648162641538044536;
    
    uint256 constant IC14x = 10087732249910916073426006557040806210935045993195380389004671191499603659207;
    uint256 constant IC14y = 7443393664317545329254912123081736912386566669005719193913868247214148583503;
    
    uint256 constant IC15x = 16404969434890860611574834353483070312895732476387812161187868979316241878917;
    uint256 constant IC15y = 19676747737804121937999539792895793757453717532009730518885557633073507270372;
    
    uint256 constant IC16x = 11130436916472796659130880446782841087239080661463103611590285506562232306164;
    uint256 constant IC16y = 13396283331421200879055216177372556296918660983129101109962712961278727949285;
    
    uint256 constant IC17x = 18218360746339548031724109374686253420716818661174497636632005644706100544635;
    uint256 constant IC17y = 21172625106199967128593353246092551188199701584176729699213074514231209994675;
    
    uint256 constant IC18x = 19758930414401357761821077915160309020962693098586679596228991300362584487736;
    uint256 constant IC18y = 13569184175490052261123892597281797139167978224682715950489992695657542966533;
    
    uint256 constant IC19x = 13280061894247793894958942691701119684528737183396784669637060695805643386178;
    uint256 constant IC19y = 13473180960238185615076221510950965535376963989105989970070499050578446283305;
    
    uint256 constant IC20x = 1883062788684859331882578642430274233076862028256499324766210198222044285374;
    uint256 constant IC20y = 21175110562847535813966290632423195949054616850607561678958250643497836918190;
    
    uint256 constant IC21x = 12895836754941507779121370416231719346694197724945981683615558906276745887603;
    uint256 constant IC21y = 6646006890301769910107555005644233902910512644919054229046263085688091816853;
    
    uint256 constant IC22x = 17308914241678938030422526322338288734470378999652358159021166607108962704968;
    uint256 constant IC22y = 18406851446505143717056856075557317602320041669211343434213146566599365910852;
    
    uint256 constant IC23x = 7080930845263346356578029481773118223285460683970543357645916770136148160025;
    uint256 constant IC23y = 1811823263315974161935966519923924161086093162314533117675697138869841933466;
    
 
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
