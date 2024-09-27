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

contract Groth16Verifier_AnonEncNullifierNonRepudiation {
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

    
    uint256 constant IC0x = 8571612681709558591409185853049833232841945740979669245942718805770032380418;
    uint256 constant IC0y = 4189972351843195639401511415729412827254667296452453166826430868050312666905;
    
    uint256 constant IC1x = 4163740772828829266948194278669903507270319410466548340505259749580941875041;
    uint256 constant IC1y = 4119446895718161137464133993105876329337486109593397680414165178003511399535;
    
    uint256 constant IC2x = 1076665331615643748649917182793093461933091169232882102136380819852321722787;
    uint256 constant IC2y = 11284503990410994128723740643198043818221559941282509486314256803757489591946;
    
    uint256 constant IC3x = 20720114473613646302534567518924514429086709487011736661545515973142187548453;
    uint256 constant IC3y = 17881405175937038896607983645804770283084154449564661605735065995699141192505;
    
    uint256 constant IC4x = 5058311354879615329327412393999176658691695524125090568857298819368005651394;
    uint256 constant IC4y = 7506574827555802057910760574778092163919955480247054085361894121784002252830;
    
    uint256 constant IC5x = 4284934050995860133235888204711867898087349447121328188587245745046901467086;
    uint256 constant IC5y = 18042265561341689884529821061557150842299623224487371136883307679833549634472;
    
    uint256 constant IC6x = 8436223819170601999808340736212420134796433124838266991859940948334516183700;
    uint256 constant IC6y = 965469023392244424047133803910012874468660808661173287907624735824491612338;
    
    uint256 constant IC7x = 17588366209171655946560951185513081113173736203853793660486480146448415654591;
    uint256 constant IC7y = 1192465391990703989331087184113754948028256726783406259933657503974466671665;
    
    uint256 constant IC8x = 168966490099400379038975776147802839111482559083939093660476845657869053000;
    uint256 constant IC8y = 1234470853915082062457367730786282590549318011417803333419252501540769751197;
    
    uint256 constant IC9x = 3709604944634147209334455029878639800199471874775000621752061808394762166395;
    uint256 constant IC9y = 9146687878469641700004378116117843217732228553171960469531573926524537911901;
    
    uint256 constant IC10x = 12725725961256189035553204906513379120207000192517003228780502858372555519592;
    uint256 constant IC10y = 20292338833910734262099065452288541371398942933488897458632976213407533951394;
    
    uint256 constant IC11x = 18955639050018384739189429546452452431567306058614310337052018081807684495533;
    uint256 constant IC11y = 3304188715918731862810019389584924243200498693827699728455473963148534993495;
    
    uint256 constant IC12x = 18175421830211350230098848584803964644934745149377427048998467617030485113172;
    uint256 constant IC12y = 14516289575097451038041879045497099667944480990058270446604032532147417160386;
    
    uint256 constant IC13x = 20703913633544089237739676885979485067605692382925341307919172314076756892406;
    uint256 constant IC13y = 642930538082700406509620387268174629787369194800127820783409323121394077548;
    
    uint256 constant IC14x = 5011985779844308735211947324326280728516252153066838956403905029573499193895;
    uint256 constant IC14y = 10890146971840553265423526563604361341331666839182598881878766582517239983251;
    
    uint256 constant IC15x = 10821352802689599315752371964308636751309190981228103389002201289657631324349;
    uint256 constant IC15y = 7196475991672579618238102963540480092819420293201416958700828001607337766762;
    
    uint256 constant IC16x = 16200509200921126318540421002813270144204087623594429819464886812910956032273;
    uint256 constant IC16y = 12398863974686923220636271491718432049670009085477532893845695959848586110538;
    
    uint256 constant IC17x = 3722494493562374096779548613322724174942518073757700482997308659102304388980;
    uint256 constant IC17y = 1266037034894012479954726512477114287010783787937671206541425973092739793928;
    
    uint256 constant IC18x = 14949633667701557044321074055882819212965657262091409079548889004592979056224;
    uint256 constant IC18y = 4896877872529145361529000973306993006588200977028415965890239754111837780610;
    
    uint256 constant IC19x = 19600655870806765152484750663334645204399011582493937511443218392447908725013;
    uint256 constant IC19y = 17754765216538248708160638759828253274305335189767407100129601709943833446645;
    
    uint256 constant IC20x = 20500642209489343563675058328337586996965591983608904858579339496029535993114;
    uint256 constant IC20y = 4013612443393979029985464677605180813213756206695459820247058152658294141186;
    
    uint256 constant IC21x = 7845584120307877467433491117843293698555121947251554311374427191080399715335;
    uint256 constant IC21y = 18711522093316415746857079798828891651730762350856485483697348191660532852948;
    
    uint256 constant IC22x = 12527418680107472024559886062863784854086212477370792890464899129756012223359;
    uint256 constant IC22y = 14485094404442660396587300748219223593828251711389859449675270566460567859630;
    
    uint256 constant IC23x = 2374481620185698836020312696466603934621248128981543987727551892572305009444;
    uint256 constant IC23y = 3107640763405757286345011943165042777559207875175588446352412264129435124284;
    
    uint256 constant IC24x = 352836510995482130410749321611349182913869955181037073971088654324262657538;
    uint256 constant IC24y = 10575715137538690696679961984361209302740638120913882703031704359365094149120;
    
    uint256 constant IC25x = 3864900267012451409819388180515893211458404339871060710177620481064569630228;
    uint256 constant IC25y = 641317257750219804481626218147534142962247182372429704342221253818145479534;
    
    uint256 constant IC26x = 16079626542421778998718365530171073924884753502101679935783606660432640673050;
    uint256 constant IC26y = 12610874584620513420871225487222612101246696013526558071069853825308942977472;
    
    uint256 constant IC27x = 15564183914008527870451816263430121365010910584399326747649241522998927982710;
    uint256 constant IC27y = 9310727885966353124231888075067724840862534920133017880046124759395997376119;
    
    uint256 constant IC28x = 5858868713515319592309521711701051336825077256643072256184630439606079470243;
    uint256 constant IC28y = 21763693642515833043829823082891009326312542712282974539414548933954053972366;
    
    uint256 constant IC29x = 2267072142710394267785251333917023575138580220304645280510759865233629259514;
    uint256 constant IC29y = 6847574567340777057974207710090179891213211101510895215166536480521144684536;
    
    uint256 constant IC30x = 2775387542501250317450085465990653835994847735739342327610585386819314392309;
    uint256 constant IC30y = 6496689167510393229055140502702806194342807614260668591022841589821989278326;
    
    uint256 constant IC31x = 1720127258124102351023626080697799543086781758010538392575993703209842655123;
    uint256 constant IC31y = 11464393770291359854991381353189019086430715171543842295218850565441402138453;
    
    uint256 constant IC32x = 5775340660326796190718199400618054551012073967006234068471234008078886524131;
    uint256 constant IC32y = 11492423277455925604320894185275809923924417874855079451325251044107376402058;
    
    uint256 constant IC33x = 1883989236545183396911270005628214060507716233705894981367212667458226321188;
    uint256 constant IC33y = 6285132610013107218246782621300082173877300940626476215092030432506329407343;
    
    uint256 constant IC34x = 1970835801922583310463821681650902598490412604240847378299403490158878378771;
    uint256 constant IC34y = 2645173405599237655242503972801246968260683155764579097820353770413386724954;
    
    uint256 constant IC35x = 13002452596664868205033653166611933658513745221555170825882755664006719154849;
    uint256 constant IC35y = 19932557513178190957639255543609719543999931993959491177552616421670733371515;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[35] calldata _pubSignals) public view returns (bool) {
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
