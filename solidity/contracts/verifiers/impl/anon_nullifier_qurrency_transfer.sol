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

contract Verifier_AnonNullifierQurrencyTransfer {
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

    
    uint256 constant IC0x = 20733445852606383356291744500876546487383238126191362579636224894844796576236;
    uint256 constant IC0y = 16344933760415477810003931798659862386900548445234581707123331936370130288476;
    
    uint256 constant IC1x = 11434692840861464677072592069266136533401537839679859604881164838623375756484;
    uint256 constant IC1y = 10437962003717259611588982131329502648441470201075754302371459945536989275298;
    
    uint256 constant IC2x = 13392027325041804749923544446077473425477559082045734971281366491588460799839;
    uint256 constant IC2y = 20748386056788237861611590868155107768744331653740535990275636858468154036936;
    
    uint256 constant IC3x = 9608672636239556755352984895556902509713177137177617177234908296224356208947;
    uint256 constant IC3y = 17486993923126864195781759764561620758724883771271050712177138254184979032881;
    
    uint256 constant IC4x = 4479902495295804474048845113634565933865076780838726501342018542897407595714;
    uint256 constant IC4y = 21296442523932409518182167468828261444258125454402119403983206891864564957268;
    
    uint256 constant IC5x = 2739233364753671141200240925686325623498668002711783995530457809448990778432;
    uint256 constant IC5y = 13561377761687374405404182251262482712837800753214660653398726783738593053378;
    
    uint256 constant IC6x = 13789367897624347504102556205329120657722918501239630157143653235966582897462;
    uint256 constant IC6y = 6517816868137166199423029303030781057922390153956969032277410626946985309956;
    
    uint256 constant IC7x = 14613529835417293036897176352117192494068437459007035714481149295175352992464;
    uint256 constant IC7y = 5166170859717082150905041202232606502726630369510889970752166301285332386874;
    
    uint256 constant IC8x = 15548499766051865001576788113391030625495834448044602750817243322263224229866;
    uint256 constant IC8y = 6192542289823326470614842303055183376790147083180169986913036502834376365641;
    
    uint256 constant IC9x = 14555174351025845137175778747292119987092318228736234585743829144776475508816;
    uint256 constant IC9y = 14068579312639342005545957191771033240660885991675716188180281064746051758052;
    
    uint256 constant IC10x = 11310434061218224847451120804432982462060034552114003687348483279401956439218;
    uint256 constant IC10y = 12296477125976790990977934264599135226905840455403295468798796891847902024428;
    
    uint256 constant IC11x = 1359340052215024766366163621569787623134178471449626849329392701262267363117;
    uint256 constant IC11y = 2799039351462471438673017992796373244124325852157500618319429657913255191033;
    
    uint256 constant IC12x = 15759672476630510129335719237682078474606135500998497943078409590224064417190;
    uint256 constant IC12y = 819254599104596890048168436668850954432831097254163457784603942365367171597;
    
    uint256 constant IC13x = 8892943727340751853327016632705606944388155969067757726870256728574294126575;
    uint256 constant IC13y = 17871860521835258529814958749706801534411950372149211536963453623432607528743;
    
    uint256 constant IC14x = 5454655901641941666597982037904728278429594241317675742629762635622752289587;
    uint256 constant IC14y = 7027421569936029028444456120246832214548747906847742204056395680314874808513;
    
    uint256 constant IC15x = 17947599171821591104286576604397056719008160950410390798563117542632089699676;
    uint256 constant IC15y = 15258975885766786528271650498473249297775364029465571116094005058595254531171;
    
    uint256 constant IC16x = 21401112605181296224622610386974467422094939652179108891898549573621800850124;
    uint256 constant IC16y = 17430591999148304453988665756736986346203633135434098067641564115948608318780;
    
    uint256 constant IC17x = 13523921444819031585926561709073468590517469398833717903572558518930254183123;
    uint256 constant IC17y = 14209461412205203813842633711345735817709665785110929833030384428147408599329;
    
    uint256 constant IC18x = 3353066601965727673011151648090839987361230399307438289982261379657492510066;
    uint256 constant IC18y = 8346518784179135222521611496201054915306649416521129673077773505612918185433;
    
    uint256 constant IC19x = 10378729189640632352026325761903244237261216288620811774283123671917991519321;
    uint256 constant IC19y = 11918646451095915989377910476718173230145514194729787089343308726416816864841;
    
    uint256 constant IC20x = 1493257107706351185568590259091241287347940648837345691310547312737694367487;
    uint256 constant IC20y = 6863128202120832783233682572555674111478100537514566996334202753648088689506;
    
    uint256 constant IC21x = 13779675015847875856129001306082896408864101408734464631018055667870654474446;
    uint256 constant IC21y = 795387724277918082968679442916120170202591578979583828454919150046578896802;
    
    uint256 constant IC22x = 18651087833660759838944399154077360512482261524286318469423225387092719057439;
    uint256 constant IC22y = 13042388856440840444061564940933509703329582747089760230193420154564675229860;
    
    uint256 constant IC23x = 21309441185196969508224055474519646539682228120799123307749472842238474509921;
    uint256 constant IC23y = 20991944982406730973147465156944738788939594586182658671197150083130577766786;
    
    uint256 constant IC24x = 8052416616370344131536817225247944134955542809327306064849182012547759355637;
    uint256 constant IC24y = 13932799863757301492336718606906431301235419661021529864005182379659583881198;
    
    uint256 constant IC25x = 19232450626162002283739942520538839060276260486612786801843728269242868715296;
    uint256 constant IC25y = 4547928248818770285152181670500986617854008741962209631589504752138821606342;
    
    uint256 constant IC26x = 3784394394512514957313359985330716490553366683923414630315778875098643005778;
    uint256 constant IC26y = 2346085656780012382556977643772100056584879963575117553942420562940188056070;
    
    uint256 constant IC27x = 3793359423289942880695291330379894944436347584893395943326289876130147623559;
    uint256 constant IC27y = 19927094305903315979322479714794198168072097836109015843345362501276323406742;
    
    uint256 constant IC28x = 11497424486209483273194964542116062576971875003300733969760978657786590514361;
    uint256 constant IC28y = 12991464267200010496015340323878274207593478719689649741430342820935937732634;
    
    uint256 constant IC29x = 4686803672685167060093919117543102009744031546720084524864564220609818035280;
    uint256 constant IC29y = 9423681889997272437244637479945027154512762404880242927740776531510293860347;
    
    uint256 constant IC30x = 1852488118066361182502516473814780973597784729801700741524520117504441356224;
    uint256 constant IC30y = 11410590698817592871776289599972573823862891429846416144978109230731328739598;
    
    uint256 constant IC31x = 1723562129301416814614607249951905954970106733539491871130096497746175597006;
    uint256 constant IC31y = 20692227132001244025066061158923150569324385231213664211907213559932218651998;
    
    uint256 constant IC32x = 11453649369340340437489197144563140149572013991552938568874244686926209066270;
    uint256 constant IC32y = 16017923195808379610732979972086601624221881848505053808941884003834048243635;
    
    uint256 constant IC33x = 18743935051875493366993001994409673357950235752086047424759814872781728831871;
    uint256 constant IC33y = 21178245446454098396961023820096491083410451874239438911448579569551210432283;
    
    uint256 constant IC34x = 12505844689334556623217390928828599233018302299542644172719574139814647547208;
    uint256 constant IC34y = 10826005036076004376496628756739250845279120165781160307701254907561298257876;
    
    uint256 constant IC35x = 12107101991129170679789519088106787020779896638202341850648769649622725321587;
    uint256 constant IC35y = 7645359211341285914291708300787426016561538154252035137270109390938814182627;
    
    uint256 constant IC36x = 11834967251841055936181037242113173380039790386008172277753229854620889966766;
    uint256 constant IC36y = 662262076455961012587175439333354319963530084266160192338814767175645324285;
    
    uint256 constant IC37x = 10911807838955501467426319553917550609694790384877318271608332852188322623123;
    uint256 constant IC37y = 17879550029901749163311363442324052101611917368383024930950626085790832286094;
    
    uint256 constant IC38x = 18729487520760491389130808020684650214460466418421977516348856701173905675413;
    uint256 constant IC38y = 14152963568755278834159867589284593287637765112617992354918200582783366958241;
    
    uint256 constant IC39x = 5043966786681202991627269304230318999705462384895670069006329604389818105330;
    uint256 constant IC39y = 4791828130097488441798836049904643414032749455205970335807158836038975714433;
    
    uint256 constant IC40x = 12231088080912234488582839634302011631358790142501440365382887030865416628780;
    uint256 constant IC40y = 3315985041117189951256471449857009455314226051729395301741623725448271891136;
    
    uint256 constant IC41x = 11794873364769654617086636663152586762266208152578101573413547381850075460962;
    uint256 constant IC41y = 9668424116200460609124056980797928617545718616401424323949240520092035107218;
    
    uint256 constant IC42x = 7719146521754566896457978221034628029774632261248650686826424489512223407393;
    uint256 constant IC42y = 10384021521651715948733116133291704158464968068670352205705600027938216830729;
    
    uint256 constant IC43x = 5014494437373554335267162206960693493955568139714682151778997429266822727643;
    uint256 constant IC43y = 9600980610131828820825266976101447406980686352800712040927723066724877443219;
    
    uint256 constant IC44x = 8916487923492851921945056543860873237348942060515478454126999145782651664080;
    uint256 constant IC44y = 20887311189846175810428563501746711419462312628716916339360259412564977091819;
    
    uint256 constant IC45x = 16239311320579773673528983928339232020351253298968220557877744790500338346482;
    uint256 constant IC45y = 3506304448264879628681127840389293476495301821236313756531688639657805970629;
    
    uint256 constant IC46x = 11836929287536705066889853932164460701112055157590324886014171990199694495829;
    uint256 constant IC46y = 637103433604954632282038643768924592504115769740503648816357626159328875259;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[46] calldata _pubSignals) public view returns (bool) {
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
                
                g1_mulAccC(_pVk, IC38x, IC38y, calldataload(add(pubSignals, 1184)))
                
                g1_mulAccC(_pVk, IC39x, IC39y, calldataload(add(pubSignals, 1216)))
                
                g1_mulAccC(_pVk, IC40x, IC40y, calldataload(add(pubSignals, 1248)))
                
                g1_mulAccC(_pVk, IC41x, IC41y, calldataload(add(pubSignals, 1280)))
                
                g1_mulAccC(_pVk, IC42x, IC42y, calldataload(add(pubSignals, 1312)))
                
                g1_mulAccC(_pVk, IC43x, IC43y, calldataload(add(pubSignals, 1344)))
                
                g1_mulAccC(_pVk, IC44x, IC44y, calldataload(add(pubSignals, 1376)))
                
                g1_mulAccC(_pVk, IC45x, IC45y, calldataload(add(pubSignals, 1408)))
                
                g1_mulAccC(_pVk, IC46x, IC46y, calldataload(add(pubSignals, 1440)))
                

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
            
            checkField(calldataload(add(_pubSignals, 1216)))
            
            checkField(calldataload(add(_pubSignals, 1248)))
            
            checkField(calldataload(add(_pubSignals, 1280)))
            
            checkField(calldataload(add(_pubSignals, 1312)))
            
            checkField(calldataload(add(_pubSignals, 1344)))
            
            checkField(calldataload(add(_pubSignals, 1376)))
            
            checkField(calldataload(add(_pubSignals, 1408)))
            
            checkField(calldataload(add(_pubSignals, 1440)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
