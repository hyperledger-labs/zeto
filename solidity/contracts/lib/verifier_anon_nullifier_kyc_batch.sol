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

    
    uint256 constant IC0x = 5055457806551308648641602858341222034412598158840015521115708780357586537733;
    uint256 constant IC0y = 13929219707581595389902696873838817350282760244992317353035320295188511606679;
    
    uint256 constant IC1x = 384812557161372662669413245701867914489609613493188812590436862874947037856;
    uint256 constant IC1y = 12860908655956463609520692003694329680053096547984855171492240067568031270059;
    
    uint256 constant IC2x = 4245757302017366581571557978332016938449225411089656969177428195459711337057;
    uint256 constant IC2y = 5225028896615339531700779183298982429893702320559967566317169785842253092490;
    
    uint256 constant IC3x = 7287687849148654981012895747708827908366769337855961476955334286124242031773;
    uint256 constant IC3y = 17996946503875371212072585490004541575549367998865829305978883358153861543900;
    
    uint256 constant IC4x = 19235045382186349101136024714248182883570296517762062314890835442556015119754;
    uint256 constant IC4y = 10445862969534871462284724012399298002449431433509174810393109712910680199185;
    
    uint256 constant IC5x = 5793257897599599892774198902680213729006215564961922151132025271271190431579;
    uint256 constant IC5y = 2466460788167456760490909268607730505971771469003843693078635842050559792496;
    
    uint256 constant IC6x = 15720488526001255048979746432723542890578013167029947794898992385820379713748;
    uint256 constant IC6y = 14311705045784421188890629141750011130293194860742875435448862699949915962308;
    
    uint256 constant IC7x = 17802021095794086513460137776793901594674708183010820081754059837087028725889;
    uint256 constant IC7y = 3279157070123984955450950265387836674597755338450726024978914681965759450239;
    
    uint256 constant IC8x = 19359815959815076899131860718663451003218422169656276678015490293414151184678;
    uint256 constant IC8y = 5707354413249396553586007167737077037290919807879639509253482984035665820027;
    
    uint256 constant IC9x = 1725872725912072612422820280616871706914827579843113375313445774588331804926;
    uint256 constant IC9y = 20620006515826938608329874607147155942682434923485018310741689381366316663540;
    
    uint256 constant IC10x = 3750626831706765426764858537677116670052811859895035465159140352051254893919;
    uint256 constant IC10y = 13692950311360677852943462374966452490713261402367448787753844286139700057808;
    
    uint256 constant IC11x = 653060428867723149388680302328852007781744895445948395564351977998893043314;
    uint256 constant IC11y = 2392634140035627343217573187592457191980158492944234596081708635656536951676;
    
    uint256 constant IC12x = 848057632829020597775111744077074290599460660422683715621697125150732964376;
    uint256 constant IC12y = 1165634259060314419729348737488491625144344359196723224161937596407804188963;
    
    uint256 constant IC13x = 6796133382642935359920238417292446244470330321080780534925907136385966106906;
    uint256 constant IC13y = 5483741050238113243051555363062380525010009117947674820642104004302000894946;
    
    uint256 constant IC14x = 8106441409952625253378113001929114649422704670858117519344483339663148890749;
    uint256 constant IC14y = 8622112428188266733459194735561489345463905110379423639463881768955076290417;
    
    uint256 constant IC15x = 4191652197026093367861782866744362301385677735250820700023614166486073780833;
    uint256 constant IC15y = 15717090349026460649486119312458368505984286740916883290320790677874689827529;
    
    uint256 constant IC16x = 5776296672230138374192730225883064176242397211023286372849649761984693768221;
    uint256 constant IC16y = 14905945306820282389385882436196748471946208760613239736496576710404665224274;
    
    uint256 constant IC17x = 4559742855829181956548161432919870338437706078707185429517436408683570584819;
    uint256 constant IC17y = 16944561631661598258841334090988727293087544220259173861611247617408683803241;
    
    uint256 constant IC18x = 16587169411945221794629940460815898228634210524160576458917942354390336705384;
    uint256 constant IC18y = 15972853747600343202136943816686809165079318263907350810685749123332283992609;
    
    uint256 constant IC19x = 8821504718841425618793065011325815296592971153042906721525253559102869998701;
    uint256 constant IC19y = 20850692993225930864774739863553994587075062943341148174407941580697925793153;
    
    uint256 constant IC20x = 18063333947262282324939485446898186709216263049371107487562701926444263710629;
    uint256 constant IC20y = 2455766652297295649340171283091470728693530178189726861600654965326631348600;
    
    uint256 constant IC21x = 6498182062916319720894646129006367644687460796460948472605347749700849288067;
    uint256 constant IC21y = 15582813260747884419894348160950156371509402077228880016716350222753661956718;
    
    uint256 constant IC22x = 321929734564151171971470625175058617225940564290674576363109019639095818177;
    uint256 constant IC22y = 18273686794894913763164834634638991620791931669901681499087533156823609362637;
    
    uint256 constant IC23x = 1385448045915172689076876549717256835132700382238446872100221741591990955362;
    uint256 constant IC23y = 4022520602423424225479857596947599676554320053840239759248164835623176007564;
    
    uint256 constant IC24x = 15614848250708717650884557704667152933528951388736256422056746841520333855747;
    uint256 constant IC24y = 19021192862351359265015245362970383223928898799978594391167809319868841270411;
    
    uint256 constant IC25x = 14219104558666768957315034631425076492531498832675405478043207041480276284936;
    uint256 constant IC25y = 5968883590209381790926786851795101235787710669209775744964007595413491210531;
    
    uint256 constant IC26x = 15053045505455240382139369868913333257395507379978726369057643711772295373329;
    uint256 constant IC26y = 6261438073742895324492874312413238180887393702081809898802326658749648295325;
    
    uint256 constant IC27x = 8279402908699966876202457428874301580577182074699386896468066902620550211553;
    uint256 constant IC27y = 19174460945619058395437208583175641756720323569757488274680139821480257784290;
    
    uint256 constant IC28x = 21499793604267157825830681866304028648437840630646996537572829551777574271839;
    uint256 constant IC28y = 1005046359992507174719839503561719300473242986575812133312314763711270984318;
    
    uint256 constant IC29x = 3238614055232236444949225941125793358783200606776689162371028284906675604194;
    uint256 constant IC29y = 19495078682976583717496513165386543508605758961481274209957275264765347242483;
    
    uint256 constant IC30x = 14760129744126933213773033864361354810338779307800047348283148893032921061798;
    uint256 constant IC30y = 14663555281074618599135299437451681770150596815248880167564723598817295979622;
    
    uint256 constant IC31x = 6195412757967138718449488882106251157524891233712748777352466418003640549859;
    uint256 constant IC31y = 7789417952150316589968393082954101751776794288548848034183786949891570349392;
    
    uint256 constant IC32x = 5322112193572143306470196243206084629933090772814697697105570159589731596593;
    uint256 constant IC32y = 6535916631097085889848271696279659032098235144105942084677969420875353671017;
    
 
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
