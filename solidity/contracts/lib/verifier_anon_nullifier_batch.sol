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

contract Groth16Verifier_AnonNullifierBatch {
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

    
    uint256 constant IC0x = 20844143144179933686367702853401659001635520044243582300318059483239634177695;
    uint256 constant IC0y = 6956893127987346586986829449841068920703970681116433429161149984274729955150;
    
    uint256 constant IC1x = 3145257296588116228951217917659437011153808048295016630750634661573227655136;
    uint256 constant IC1y = 11692686976241793602361646805224113669146832518433186263786203652119894682202;
    
    uint256 constant IC2x = 16258810049061785642786324998613222807846599083981592205168287535492316537730;
    uint256 constant IC2y = 12251560167068319041987936419160993971679197422612698232359757036111894372663;
    
    uint256 constant IC3x = 251781136374948237986551327298197994537136901024713712357336516445425740592;
    uint256 constant IC3y = 6227059871063762497220415891053961379240079035599643882420648758298833266542;
    
    uint256 constant IC4x = 8649560149784748604025905683235874568511947437413239525159237000293037617298;
    uint256 constant IC4y = 8747524132149016931009206153273351341814570313184540398314387764445409252158;
    
    uint256 constant IC5x = 11524377559110038208935035612054843778802434027463732360891441909399945816797;
    uint256 constant IC5y = 18828274067104221019896291561320103025121737743752362258177323570247152671928;
    
    uint256 constant IC6x = 7385161427131949497271670148755048425729464306154555291161088833019700279471;
    uint256 constant IC6y = 19079861300823810080891280375686529744645001290941546750584479382979657289246;
    
    uint256 constant IC7x = 17934278616854511206424984073030417465445581765105585112091416104033803743042;
    uint256 constant IC7y = 14710666138261018736711867414590007817342686156878524386850840867533993802458;
    
    uint256 constant IC8x = 14707384838160911457918999203818273609600051806011767213346322440794319155905;
    uint256 constant IC8y = 13237987873586454942683016892111323980921950273085113968390467646435158084741;
    
    uint256 constant IC9x = 7562227225802748091972005428011361130005690253417511123075521190518795738149;
    uint256 constant IC9y = 4661931025029160592061867769468775700733100438820387043571605053268353675276;
    
    uint256 constant IC10x = 8832584362940380960579414511468218447553605312077025224926791197187056385556;
    uint256 constant IC10y = 9302218887041506854463034373316824720242916558732217573892008557715786667965;
    
    uint256 constant IC11x = 21209555931154727846096629287250005552280019040728430802966166542147340144233;
    uint256 constant IC11y = 2071566621746845771862041312284464859664491179818305304210166050356392949705;
    
    uint256 constant IC12x = 950277162574048517298972242135187100023190595461411049273998606674829666008;
    uint256 constant IC12y = 13575683112393817689056421975285185373895786482959786206453183726981837783596;
    
    uint256 constant IC13x = 12035747924156260190306427775717226720739331292774066045356563771007872767717;
    uint256 constant IC13y = 3362253945111797894473225828901933246093284841324718877342445660643508802152;
    
    uint256 constant IC14x = 14137346988181889936217575935826112345993273796400738991890809144357301565496;
    uint256 constant IC14y = 15637121408408019060319858805343647729218308519116021027187930932370871262676;
    
    uint256 constant IC15x = 13762873643526268013947632485931813861248721924789455076140043231430980762390;
    uint256 constant IC15y = 9963293110830377293739765877755694764499419331215622126241313239553878025491;
    
    uint256 constant IC16x = 16692574613238032287283652982184597546335524897465441956026040107887285592543;
    uint256 constant IC16y = 17292178457651461126524604559702058819667208809285906910210631878380949540985;
    
    uint256 constant IC17x = 21006997381406654206993340273166716734805806423755224685869754804308263604614;
    uint256 constant IC17y = 11276113338642452423709056895012512446623471098033288820386384037599973211369;
    
    uint256 constant IC18x = 5549790547342287258223232153342939363197412516882599097529421254710739277932;
    uint256 constant IC18y = 2321980957868435036369134816018219753345397660500077204638931350984124152509;
    
    uint256 constant IC19x = 15576570213143935319990221618758579058427975921328599747785461731895205749979;
    uint256 constant IC19y = 2934186338144369040954708903760643286101176787266350772513796084984222769874;
    
    uint256 constant IC20x = 6137477004926598404997675240907254540828053394371866068349832466271296672929;
    uint256 constant IC20y = 20888861283647246107329551100697915011175737920485206165339138558619907573843;
    
    uint256 constant IC21x = 14463409262299509615392506481758018285658547737656813334743931121364861756703;
    uint256 constant IC21y = 7332787039324208062358154360486138008259450181030941396848043512484238275757;
    
    uint256 constant IC22x = 16601356363302138980638118097559879425695247168438568916519789560117559369274;
    uint256 constant IC22y = 17787921183075222020103570772036143742977525428618366807704027634151186727940;
    
    uint256 constant IC23x = 12583431235651781757939013640433576160419876103048391410427308386104111565232;
    uint256 constant IC23y = 3986398443693889094738419603281333618352214730101632334117232653906612934881;
    
    uint256 constant IC24x = 3853568607428240670449556852094203559518256205705378610563709475235813985869;
    uint256 constant IC24y = 543064818712667001693516860666177754509195083882304081179747934873049678706;
    
    uint256 constant IC25x = 2885563210258556414381788942320848534195847749693881492631885970929346938859;
    uint256 constant IC25y = 8131940318918107670107005557739113937288882470046042271398018679856018871886;
    
    uint256 constant IC26x = 17010995670940491819617933270493324753886079844847190687868033412180995569776;
    uint256 constant IC26y = 1131002585900701640305315232975026396983461884863407554004202067072144971084;
    
    uint256 constant IC27x = 8218092164315760638693205679360581362550320900615925231277371834562473628432;
    uint256 constant IC27y = 804708916368827372063223656560578153797821838602606304217568072164318993236;
    
    uint256 constant IC28x = 5399094891216602742965040821422609449504212935322660879066435153850561721165;
    uint256 constant IC28y = 1265562530391696201126288116617589607013674244193599604325171580589223550213;
    
    uint256 constant IC29x = 12663247164972275544017007748295885957218341893889185539064234743460082294717;
    uint256 constant IC29y = 9413051200923723465055492328404732423271148428325190065591941881643336354578;
    
    uint256 constant IC30x = 10229493101680001535059987062347611183366892099697060172642147707296073449034;
    uint256 constant IC30y = 5341823103341504835994668879856735786794919965665449958641465848415231797279;
    
    uint256 constant IC31x = 17299647136322859689775136480319515957049987852882873899315494679093188679533;
    uint256 constant IC31y = 5603736654692809267331406367699483579804529124597898174480040309340108654851;
    
 
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
            
            checkField(calldataload(add(_pubSignals, 992)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
