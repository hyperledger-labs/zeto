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

contract Groth16Verifier_AnonEncNullifierKycBatch {
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

    
    uint256 constant IC0x = 11662660143860874931072351186047069691934558454076806957543648503057847943513;
    uint256 constant IC0y = 10038348414197657683445922076295262289652998118153787101974831249817368174353;
    
    uint256 constant IC1x = 8988535072375717724497491246352234049328213447683207989537377224470040054966;
    uint256 constant IC1y = 8166282710103471067373199268434356717037308329558570925972507352895336171600;
    
    uint256 constant IC2x = 18432294692910581759472826919355763187872967572458291145949908209816982819688;
    uint256 constant IC2y = 21529300506719821524307516873688911621260384833976448337733933552847314256874;
    
    uint256 constant IC3x = 614735613818836283841982905943976709929041752739745042789141794733265028134;
    uint256 constant IC3y = 3860703814665496245605558172188863798062943606333015527826728127069465082427;
    
    uint256 constant IC4x = 21110382318575147474338865721398707915802737103567042212867029114347240559300;
    uint256 constant IC4y = 11477828230558650608120671853203757664438453457364362308796561794776172008451;
    
    uint256 constant IC5x = 10955202528924804812958438713742990627683883390569205805287044297181502266729;
    uint256 constant IC5y = 17858987609351477507179059147091144336664455743112357073106373084043189280164;
    
    uint256 constant IC6x = 9247132710507257341694745715536030078362897235873976845653448343004216578059;
    uint256 constant IC6y = 4077530447461105776970121739853125425415755933636891068527434065606633343729;
    
    uint256 constant IC7x = 9282229099621743758927934855838604257685882618355194980012233357617245438364;
    uint256 constant IC7y = 15674736937935764122279448687928959717281418334634353011570533455984105715121;
    
    uint256 constant IC8x = 9722132009325333783456053646735667902530261615407197523392160208704603988454;
    uint256 constant IC8y = 14618244177095367221394852282157340600459069670233465954719723502618367220099;
    
    uint256 constant IC9x = 973628821824034631277519892548216364093065392435755888383034381618210105026;
    uint256 constant IC9y = 19130664929693827307694622317521885236690764504040079683400014381939179764886;
    
    uint256 constant IC10x = 18497489122159836005440235191181397682168825652742401878718303497751950476573;
    uint256 constant IC10y = 184674817624142463950860554146189016898202305618730035365532664689559015024;
    
    uint256 constant IC11x = 20742886562308807174975673124416469858072816509700038966264317699622470845864;
    uint256 constant IC11y = 6892841648413503913935428607180182195114904340636618216544980552932522306183;
    
    uint256 constant IC12x = 1554767197776271090848221696659744029443606469011424330576588038599488901790;
    uint256 constant IC12y = 17824173807300533295074190605171784659758705215735044173456990718107986673990;
    
    uint256 constant IC13x = 8926678800934477977183437663176073269804039617131246226117210958642974831665;
    uint256 constant IC13y = 7759817179292182986840792444788081906199101563123339998406609301418454149912;
    
    uint256 constant IC14x = 892387531981845359273038619022215455220935019529138222295972719463971685626;
    uint256 constant IC14y = 21664606451742576757250844476052733616001992300681450622144236517957407335395;
    
    uint256 constant IC15x = 11644738412527836785033238753051417149187120228925099428899706835198503714732;
    uint256 constant IC15y = 20385101286516026017516350545863829411647430450169209244102096545003646405227;
    
    uint256 constant IC16x = 6914380489103854988747068027174251954079888530380820907417133182165125002895;
    uint256 constant IC16y = 16001027808620196049156676450902737881221224855685201356892867218134413591974;
    
    uint256 constant IC17x = 14819004697379517927442020076999128258818136109044427450238213315710239729290;
    uint256 constant IC17y = 18234035980915600023635619254964104942336216004642311690220730031352749295516;
    
    uint256 constant IC18x = 10782655998802736438708390186837190841583872252631539739869717362042994127890;
    uint256 constant IC18y = 6223193220871490512854223407339053827650007826976048957711920097140884329831;
    
    uint256 constant IC19x = 1895164154807081669060491556433373630284427382709469252391398895819775411625;
    uint256 constant IC19y = 15502891301545941170843587746206524939661082838133458062213752972874935576258;
    
    uint256 constant IC20x = 13887414818061216296960695706977042112426565238817982814880739463438328917279;
    uint256 constant IC20y = 7484477067983396480837362197475960184311309962467034141451929400540619439308;
    
    uint256 constant IC21x = 5054771292297611149580407057004026930126834333985311096593522198136005344912;
    uint256 constant IC21y = 9846301605360728746360669788291305483667978418447570933133518441453812077532;
    
    uint256 constant IC22x = 6375011858346699471620766703454180460474959318906959854737520006721913377252;
    uint256 constant IC22y = 3796913124771080981656421285118700913079563083089989934442241685039240456288;
    
    uint256 constant IC23x = 12664019414260530425201012729657179596363883228871830375986018330410576140745;
    uint256 constant IC23y = 7724324759234305150098870450511243647469859115829862950119746163372770734859;
    
    uint256 constant IC24x = 8414475932517376718246446511190686353933356473167597163507393977956520237760;
    uint256 constant IC24y = 18567739092665780186541027431450016060501602309168108628165515395048109525145;
    
    uint256 constant IC25x = 3120359907362450985974214561527700848503852347080997608106866995365092938990;
    uint256 constant IC25y = 15598034416975435647171366075254343399116960825160529831975796905883095316090;
    
    uint256 constant IC26x = 7618398623080814369986094262260112943677198176279294076050134118180709564420;
    uint256 constant IC26y = 6351701903764767447401679181425343449080736954061708171606650791995388240779;
    
    uint256 constant IC27x = 7660149068846033504478826117178890832918932678832205596487410124265824854510;
    uint256 constant IC27y = 2491826788761961957821876406677372156214488096819322910097327511124260678669;
    
    uint256 constant IC28x = 20794838749313203903911030270946907016433597109553720174221656385211714777857;
    uint256 constant IC28y = 17812498163364921099637863734271985783984365300073299650639268105274324002530;
    
    uint256 constant IC29x = 4470726918138395764759380807649395990732471367466166253310755622776103465819;
    uint256 constant IC29y = 17507663986159322748561449962825208817145248778005235057962503024107788565141;
    
    uint256 constant IC30x = 2282738716454269120180527219287809294651441549016730273033210373774062724582;
    uint256 constant IC30y = 9623151597448060795671840649081334455274395484568727058139159897873039048540;
    
    uint256 constant IC31x = 17305720772558963560489472259732910387932131794541742579825391441778640282514;
    uint256 constant IC31y = 17978483020480616572180687903365084753182987002773905082575771176385017798184;
    
    uint256 constant IC32x = 7571937518121766238677733127868492321558436932028274617193759428484887548524;
    uint256 constant IC32y = 13639634797327254842916621072030476726854653633267901223609159210218680193213;
    
    uint256 constant IC33x = 20491321178426427862122967005183398251779924470644678424571372683050891038410;
    uint256 constant IC33y = 11866037972312670211817727171740620564847008846992179291696597777640193650198;
    
    uint256 constant IC34x = 7405036655032262031472090543721788457203124544189082692990295451049187204918;
    uint256 constant IC34y = 17405807581678636956378393569562099137850325108621234185518676366335548019795;
    
    uint256 constant IC35x = 12328260325084982532450273571086533395727110714550084687965119377605785323469;
    uint256 constant IC35y = 8142505738758504286142612135433392554621238433204631934113088648731836869316;
    
    uint256 constant IC36x = 21455489380416043414802439866337341338095098412697364482542368506991948195301;
    uint256 constant IC36y = 177380340269897070531510667485546719600921933001020617304645726088643982991;
    
    uint256 constant IC37x = 3450411197718861866556684118720127022485036312758274952373537023832934853655;
    uint256 constant IC37y = 15542683513967475831837975619927185145121842635660806931638451693301339778065;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[37] calldata _pubSignals) public view returns (bool) {
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
                
                g1_mulAccC(_pVk, IC33x, IC33y, calldataload(add(pubSignals, 1024)))
                
                g1_mulAccC(_pVk, IC34x, IC34y, calldataload(add(pubSignals, 1056)))
                
                g1_mulAccC(_pVk, IC35x, IC35y, calldataload(add(pubSignals, 1088)))
                
                g1_mulAccC(_pVk, IC36x, IC36y, calldataload(add(pubSignals, 1120)))
                
                g1_mulAccC(_pVk, IC37x, IC37y, calldataload(add(pubSignals, 1152)))
                

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
            
            checkField(calldataload(add(_pubSignals, 1024)))
            
            checkField(calldataload(add(_pubSignals, 1056)))
            
            checkField(calldataload(add(_pubSignals, 1088)))
            
            checkField(calldataload(add(_pubSignals, 1120)))
            
            checkField(calldataload(add(_pubSignals, 1152)))
            
            checkField(calldataload(add(_pubSignals, 1184)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
