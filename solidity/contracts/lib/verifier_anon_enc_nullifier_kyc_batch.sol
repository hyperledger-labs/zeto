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

    
    uint256 constant IC0x = 2557045328174556474259602364787060617413037186775787740247120052256591101057;
    uint256 constant IC0y = 8545914595700052385922827053758169584458550417191596397077967009342340172963;
    
    uint256 constant IC1x = 8900866652413972639447801185066566440613708319253275484468074220706268630752;
    uint256 constant IC1y = 18117300326867814101825535845382858738704176302675336121313760471944027618579;
    
    uint256 constant IC2x = 6893165486528724258452539284348100242940680901205710094027141947523508922556;
    uint256 constant IC2y = 11428083713288237383922201052960038086381204628185844551802602980459665852296;
    
    uint256 constant IC3x = 2787509042012632529212775966824220639705355486752580713355548540317374958318;
    uint256 constant IC3y = 13559075319591979484148387886304036951246196260874348065387705986067180861572;
    
    uint256 constant IC4x = 7981603848980165083052696916252376820361500997039057002907078064409646042704;
    uint256 constant IC4y = 1631170154333774225978701321671377089584774646241757146636720110297678397686;
    
    uint256 constant IC5x = 2718945106954835265374519388993004950467939770842588234333099827036921488036;
    uint256 constant IC5y = 54129075547188978676123602750315602783350522469912352491032758031739397264;
    
    uint256 constant IC6x = 10147624070030089461943558234086476925326752621677677347469962144928874051171;
    uint256 constant IC6y = 14137637656464541694095908034649703224311668569886704894187366498167267119930;
    
    uint256 constant IC7x = 14131833902483915573002378883085094517189637884537825125543294251780418938907;
    uint256 constant IC7y = 8350712732464638756493234130405621139170404316430682690462953318721564280425;
    
    uint256 constant IC8x = 6466504309236504330936004664742363699367258661498527049422417011059950380261;
    uint256 constant IC8y = 10308743258353094916300411811569013911785525949453696511480625272875805213094;
    
    uint256 constant IC9x = 15034560127374538253652390881068026376032149277012915824928102233595801597871;
    uint256 constant IC9y = 14933364448090705000296248910019334925480794867671226328859117405842595498286;
    
    uint256 constant IC10x = 1435567384244739999636752756588097453785728405750034036596678824485141706320;
    uint256 constant IC10y = 21045412560666440575260065642431316733861600716932140912086713771905478605642;
    
    uint256 constant IC11x = 20660910050407044985841964548615754563198335468098466571354791341814009582143;
    uint256 constant IC11y = 17161276760446539174103283658490390916497070640753169765510233658752644125327;
    
    uint256 constant IC12x = 14297221549426245599275426280912312242758539460442195637765479076821005351090;
    uint256 constant IC12y = 7045746153755160132606239721075319853671165146167794961048168331481327369378;
    
    uint256 constant IC13x = 6709297759563652448455456777394655766655295904612361150672442940274698264117;
    uint256 constant IC13y = 604939571031743874843375836514454028390240836996444630147060119881962118591;
    
    uint256 constant IC14x = 1506931283257291434315981891710633368372940860477458257990053769650899625020;
    uint256 constant IC14y = 16234509187615275824159269295900874844499753487293080637471224460931211356610;
    
    uint256 constant IC15x = 3663986373923028376047433528346986422113085036111303782126649588832018217222;
    uint256 constant IC15y = 2833212771516071304842292770750586061301584725053640822674852019170921553978;
    
    uint256 constant IC16x = 9441974398462151962861519019668159526029441202966112923894683419951453007203;
    uint256 constant IC16y = 20398645667686807455795531059467229874168827249918904721471455262548811448301;
    
    uint256 constant IC17x = 9941969049637054555017138554864083807451665108028251180781197146279496720189;
    uint256 constant IC17y = 12083041856346926425137954851405721196793285382115647784815644983516676101313;
    
    uint256 constant IC18x = 4513953042000608174347593715577667089282919422419113365380162468063688775130;
    uint256 constant IC18y = 17768548800782673039169889569716085142981878050151504480878715449322827273410;
    
    uint256 constant IC19x = 12249598222891158199710492081231845984159762606864132240852548984852903893394;
    uint256 constant IC19y = 8218081839064592605577365459229129812592277515386687488909134942995986616646;
    
    uint256 constant IC20x = 6813471708188402912338247638719280180144768836532653959906749755180831733701;
    uint256 constant IC20y = 10630452899956666539442022832713171293838832707279857274903723291215504725074;
    
    uint256 constant IC21x = 4645195348559291511944588819754123347451366573885154192985637448206304620124;
    uint256 constant IC21y = 16766206162461102255042753211815836900424951725074557637817692932957001273876;
    
    uint256 constant IC22x = 612198738216091583770089992329981011003570889532673265272801632641592335601;
    uint256 constant IC22y = 21009776677696441122580148742821355608472017491940177896149934304781750294343;
    
    uint256 constant IC23x = 7845708505520385664103122252124442232529534143144281637399707935968372058244;
    uint256 constant IC23y = 15192802321724721965923896418287287881746337425062951377408799115613924493192;
    
    uint256 constant IC24x = 11044743356250821069784980936566426424857876182337346673003368733690232366513;
    uint256 constant IC24y = 21968542138387545717894491159110633336985278011066255264274935509925404276;
    
    uint256 constant IC25x = 15739104432512218764744514918039053175648927736786942938917098136624846456654;
    uint256 constant IC25y = 11473837237244115867873717433248212843653746603581652183709166795371859623666;
    
    uint256 constant IC26x = 12659745779361797715321216070590036668890759442977154045015864656515913110821;
    uint256 constant IC26y = 15436857874387771595832460190912333282587447051076428904935035331068995068691;
    
    uint256 constant IC27x = 9203173977602946543016875848991349465294047894411764290600412715281184637502;
    uint256 constant IC27y = 8557329422378274647247494844347551526466632349826006833910662893194934281525;
    
    uint256 constant IC28x = 21043592517032634711239990905884702982054744461304587368835062757863764173274;
    uint256 constant IC28y = 1631750092321340715930642498551502008794205048320252109690579472702482883693;
    
    uint256 constant IC29x = 1965593797962209845476914161340324215049454355711575611255794847486588198621;
    uint256 constant IC29y = 20420112496369531484716420634051964705303428701409013107809743921895693778420;
    
    uint256 constant IC30x = 14459258316049621520625093813598405781231837198148192657248564100568126911436;
    uint256 constant IC30y = 4189670097301689361279714226734357198747625987495488973380038361744870962865;
    
    uint256 constant IC31x = 13108879096940415310362336426378117914756114957855406964927612281735121697971;
    uint256 constant IC31y = 13922315068161235910520981793423554652810239633897980696104312477364323289837;
    
    uint256 constant IC32x = 3672774723765929810525726446377577070495042440381259398721824519467692223036;
    uint256 constant IC32y = 5504189137877852784897136813364091880095479448638215793137890720712833089772;
    
    uint256 constant IC33x = 17130781702453148735613043990802970337134477759322098512883706161057337504002;
    uint256 constant IC33y = 16351907669841445135205102522017369314355429337431004692059562467792755202730;
    
    uint256 constant IC34x = 12031667235281243664253700834599818547380367496538162959699982743848078891598;
    uint256 constant IC34y = 6616306445409952843359602511870642177994574094251005373437394528227240955856;
    
    uint256 constant IC35x = 10731123795727845951791321856155816019889142705311580809720843346374187513971;
    uint256 constant IC35y = 16068650898493671048010070098850477199748100710010759421745286594693280298357;
    
    uint256 constant IC36x = 6502894893010883942423075381722837038696334248009036389776781991138833860268;
    uint256 constant IC36y = 20790809673001992281463007604198705518066093384563083477497988619198326219881;
    
    uint256 constant IC37x = 17893528808061411108476748553695245038781846398552576836224230715924125892190;
    uint256 constant IC37y = 3396165818344392654074158537612720431771510878758650774669727330733546082337;
    
    uint256 constant IC38x = 10897508493118616620048369575610774538686816226070866208104945341887798715990;
    uint256 constant IC38y = 3477357433659395048329281632040211062291869085580053535523965138254126524307;
    
    uint256 constant IC39x = 6232305602842554721699996063058147937412901964622386302125531286379410216341;
    uint256 constant IC39y = 865167260793798759680935843664150177300892974890677439296402891134136533334;
    
    uint256 constant IC40x = 1896700859908460930091624595675776615402193748854462019745978620107291409907;
    uint256 constant IC40y = 19538419883460717066552832903405877575081999780942435734967867221406789589399;
    
    uint256 constant IC41x = 919917946864295765320845049317324032542470918660595400102049568313393745259;
    uint256 constant IC41y = 4905312417092777244239947166508788614667233335337264831713809305929873826211;
    
    uint256 constant IC42x = 11260058824584772528807061119314472338786531909501746400162839164183738065949;
    uint256 constant IC42y = 9692558976165758378143630277186357355884473671639921608383879688904015447492;
    
    uint256 constant IC43x = 16500664765246509026092343746736878544449617806107262161088710179454171005068;
    uint256 constant IC43y = 2318970865336931978806827275921781650216283891871191849842243055051647241566;
    
    uint256 constant IC44x = 15266083558060117092889105437693230282542989249077821947771936425702618705353;
    uint256 constant IC44y = 5933912916741823626580572218992545666034550775510312837553273107032523100335;
    
    uint256 constant IC45x = 58707545314175203397280970210969715660178168988171479206762359173733595778;
    uint256 constant IC45y = 18337733572288419475605999960151866998282044219653232437655934170784662568961;
    
    uint256 constant IC46x = 586233669714266072235077089672820057713553723712257638939984508768691446266;
    uint256 constant IC46y = 5805420287012844261801028660062719860928333497295759197250699480287517497513;
    
    uint256 constant IC47x = 18533811404590119489507085680888268159057504006917018635283187815937097547211;
    uint256 constant IC47y = 4105347632669743236449600156045402810957294409584662993772317423421882395967;
    
    uint256 constant IC48x = 7963255695223444100125880939097224728146759221469423275545846145917825941948;
    uint256 constant IC48y = 13512044941955473329651037303898509853731877911390554418237190804988526456008;
    
    uint256 constant IC49x = 1246040208265149753842480934506849680611118792544861176402750181192234961189;
    uint256 constant IC49y = 8563441033219483164633277222289522857294420978768986809528993427373045444984;
    
    uint256 constant IC50x = 2588594350644268564085849031861239502254810392738869347650201531798451495394;
    uint256 constant IC50y = 15910783489501827060267126604385240212657463315742131285497095914663726625032;
    
    uint256 constant IC51x = 13536358811202144933899812454990919546110622582416000445508880943657060919439;
    uint256 constant IC51y = 13636439389086566021867409527624225391658272934816689794906398506550354679701;
    
    uint256 constant IC52x = 3069052660704238265078596844313226533136449247403800942357593600286959491284;
    uint256 constant IC52y = 2851907145042254355715210427589229005946148117819918992483522956786765330528;
    
    uint256 constant IC53x = 4532058296252955609362103735166225278277027937093609645966321436167953753849;
    uint256 constant IC53y = 16885038322595100901701279116331564344696993077930991807708669198697751982536;
    
    uint256 constant IC54x = 21657088241609806957806596139919891483933646681016763066971961683666639010914;
    uint256 constant IC54y = 5540503589899208339201031551963806514853512880214799648245011777415136792427;
    
    uint256 constant IC55x = 3180572821870628434033407206819005535080638863627732738600363337929557825472;
    uint256 constant IC55y = 12213704425579070357451089645113850518215300513830671326650618723999697008004;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[55] calldata _pubSignals) public view returns (bool) {
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
                
                g1_mulAccC(_pVk, IC47x, IC47y, calldataload(add(pubSignals, 1472)))
                
                g1_mulAccC(_pVk, IC48x, IC48y, calldataload(add(pubSignals, 1504)))
                
                g1_mulAccC(_pVk, IC49x, IC49y, calldataload(add(pubSignals, 1536)))
                
                g1_mulAccC(_pVk, IC50x, IC50y, calldataload(add(pubSignals, 1568)))
                
                g1_mulAccC(_pVk, IC51x, IC51y, calldataload(add(pubSignals, 1600)))
                
                g1_mulAccC(_pVk, IC52x, IC52y, calldataload(add(pubSignals, 1632)))
                
                g1_mulAccC(_pVk, IC53x, IC53y, calldataload(add(pubSignals, 1664)))
                
                g1_mulAccC(_pVk, IC54x, IC54y, calldataload(add(pubSignals, 1696)))
                
                g1_mulAccC(_pVk, IC55x, IC55y, calldataload(add(pubSignals, 1728)))
                

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
            
            checkField(calldataload(add(_pubSignals, 1472)))
            
            checkField(calldataload(add(_pubSignals, 1504)))
            
            checkField(calldataload(add(_pubSignals, 1536)))
            
            checkField(calldataload(add(_pubSignals, 1568)))
            
            checkField(calldataload(add(_pubSignals, 1600)))
            
            checkField(calldataload(add(_pubSignals, 1632)))
            
            checkField(calldataload(add(_pubSignals, 1664)))
            
            checkField(calldataload(add(_pubSignals, 1696)))
            
            checkField(calldataload(add(_pubSignals, 1728)))
            
            checkField(calldataload(add(_pubSignals, 1760)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
