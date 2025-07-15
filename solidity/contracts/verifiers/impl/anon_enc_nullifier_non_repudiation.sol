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

contract Verifier_AnonEncNullifierNonRepudiation {
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

    
    uint256 constant IC0x = 2336577094938087927295577057883559133518548539857476285365258729761282359766;
    uint256 constant IC0y = 13457134454080778366437034657939216462839606636557680623966235664985014137305;
    
    uint256 constant IC1x = 20368186655202454639947367876268302520099557539199785153247271256535591612109;
    uint256 constant IC1y = 1834073636613445034902354120684380339901954947478996148178176791706878906407;
    
    uint256 constant IC2x = 18940883460337419797153516323361463548277628324385966615136813524210829544349;
    uint256 constant IC2y = 13755507182276982182867654664182787667177703610016036825527715152774073764027;
    
    uint256 constant IC3x = 13231089068759352133229900008219856881837973267628151698550636358586290388578;
    uint256 constant IC3y = 17549483333773564289060048934471648703429804448797817402738216853563050513824;
    
    uint256 constant IC4x = 3718291145538772402489965274220064004486859595590887213015547941149991481626;
    uint256 constant IC4y = 12828270140752225962126183368645874984769198377096274381853118332823329406227;
    
    uint256 constant IC5x = 18736813172179817146165649443954222779907463495017183378774917519374574311865;
    uint256 constant IC5y = 4791019722595773462176337006847693763621610396606840461521291694242205617062;
    
    uint256 constant IC6x = 5931014294704985447511179792551174374364071929810069992592261539332350709757;
    uint256 constant IC6y = 9541115709882884474730500786593649081648338517201659311784346599311173591142;
    
    uint256 constant IC7x = 8376183611291948297555810674693859640776130390969194053869891204773398551980;
    uint256 constant IC7y = 10950568538667057429335291351211703943314971463987839309953105625127038042875;
    
    uint256 constant IC8x = 3593767593495074340761337008111485433168629647463872101352651561175062635430;
    uint256 constant IC8y = 19695880590579932433001923173116544145333001191051861405962278750909369540629;
    
    uint256 constant IC9x = 10534363381864867775914234406106233869894770875272746886524518155058125329261;
    uint256 constant IC9y = 741598727372318357175251689719337813830893380957790334465341391138232733741;
    
    uint256 constant IC10x = 6177988268268517991964317589827123117211176904991433078124281232752375741822;
    uint256 constant IC10y = 7159974907571145118809362091595035331625961360510125631245729355534584769291;
    
    uint256 constant IC11x = 14505436396580684670385719397908417679942029634979461506252828828303566999980;
    uint256 constant IC11y = 3916969919758833669916376587113539249393565525631663813333053212784130861244;
    
    uint256 constant IC12x = 4723397578636500289435415214306321312482142053702168849338918862962056979195;
    uint256 constant IC12y = 11482358689443672585265938891080500619875646195579261693717520875573178045485;
    
    uint256 constant IC13x = 797665560744131893500441063934663326654267162380346194403443121670060256321;
    uint256 constant IC13y = 17879311589999179631215839542818339376607434377536775903656521943396318764700;
    
    uint256 constant IC14x = 9486919632207017877087162467329150394235665261347272151990078948272982823861;
    uint256 constant IC14y = 17565835574889820311399751946333533815297619410872863262386968526457760651875;
    
    uint256 constant IC15x = 19112115616058262149583452170346493629958206751900606537425015309087289741045;
    uint256 constant IC15y = 16483942446382813319489486495881691719176880076097868918629055998333671031502;
    
    uint256 constant IC16x = 1769381440561277901068256687251912810646310036136671097732405838918184584563;
    uint256 constant IC16y = 15401338254094946368624334939233815548688776752970441728987022936753109856083;
    
    uint256 constant IC17x = 14932202088341980784202341310673936355907049514434300131865964269077401294876;
    uint256 constant IC17y = 9451546920315588440642292629322244245247620242160482006193062280575342323439;
    
    uint256 constant IC18x = 672229520667987543545090784453262391066694382776752692580156039640603300520;
    uint256 constant IC18y = 6884567015094573071558115833438034604426326597307147745252369288655067488484;
    
    uint256 constant IC19x = 14813104777753242287396585281234133510709992231096068253096490872613821970868;
    uint256 constant IC19y = 6891698250887963668171109644512145999986658257741300191326847994337471663928;
    
    uint256 constant IC20x = 8061507267147245403549782812736097596810599804697548464917251405795007063625;
    uint256 constant IC20y = 10657309899179492700325493323458983497622982221097459826570658967762174263111;
    
    uint256 constant IC21x = 4919553783113537587872873086014275294547872039347561984338180498370579505589;
    uint256 constant IC21y = 1762031831473245497337383734476838109418118388990267321671511418446337193221;
    
    uint256 constant IC22x = 14978532274637579989153722669443236586385229249177147351994130534202911960382;
    uint256 constant IC22y = 16644463882318425712283144214923411643577017510128454848234571609730604782706;
    
    uint256 constant IC23x = 13722326495159059027549890656342336953615701458611722945421926849086100564600;
    uint256 constant IC23y = 15586818551632966539965721394270213475738395482852094238364253324996258479309;
    
    uint256 constant IC24x = 18511253034248757976405227689273154359014566349569277333926999998093561903337;
    uint256 constant IC24y = 11905174900999919411683103806681241466495923710197271560146135244753602850444;
    
    uint256 constant IC25x = 777185121846802663554537575137789566793050107611685335313889822393378098302;
    uint256 constant IC25y = 10446743667518846534977648316170489545866393851732170149256206254163238972712;
    
    uint256 constant IC26x = 1769873661160417951727193766761287453746397976400799940894140491355196386666;
    uint256 constant IC26y = 6065470470210909002271230147957121190242835746405142690102241437741074169890;
    
    uint256 constant IC27x = 14266140188138381351729765760742904177535380603768711221397323242367801300600;
    uint256 constant IC27y = 11184719633944772728458395170571297750226790753224105034048687225921351769185;
    
    uint256 constant IC28x = 12447368959258473502538778287940565345549666576417739869817776959132935138529;
    uint256 constant IC28y = 10466129433413011601575677866754023304225876489776658804564365362437381726657;
    
    uint256 constant IC29x = 15313035936915855484568977580210063685650295261876175289687428478013701584535;
    uint256 constant IC29y = 13026492289711431688326718002844245669233476107247152893555166355998411287781;
    
    uint256 constant IC30x = 17620173842809202079236058311441204112948177028372803375700024936604337532582;
    uint256 constant IC30y = 17127452532371532056651533418242588427609733230348364296610369445374519683409;
    
    uint256 constant IC31x = 13659394369623251676552253941856223659970980908082331122273471030881523839468;
    uint256 constant IC31y = 5809562999079480828617264331821793267531173023113534849740489529791747143923;
    
    uint256 constant IC32x = 80867535813945152830009288167149538782597009557502674003006854053895143507;
    uint256 constant IC32y = 19603558764703683744638687552023794414530381632012190707734268824573646150820;
    
    uint256 constant IC33x = 1629225444057162213927967169556768453036489932501915920857135800715461648727;
    uint256 constant IC33y = 9948544631896711259435023095898776468978641613045093433106022685743310394931;
    
    uint256 constant IC34x = 9410034415848412403442596783971139311904852140664334560840529189802579585532;
    uint256 constant IC34y = 19725620098272737991736980946833730739267922004172581650909940343796470552165;
    
    uint256 constant IC35x = 20376978433617177577490525105928032566950148738759389919309796591019368562503;
    uint256 constant IC35y = 4826560903129273765266172543265291733364642769359516979133329505925361076766;
    
    uint256 constant IC36x = 17935613802792654904384129981780058021038639066427757791407716421750949434300;
    uint256 constant IC36y = 17872468359027094939389570111807409259649878886796616615635183600078561384005;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[36] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
