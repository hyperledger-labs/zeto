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

contract Verifier_AnonNullifierQurrencyTransferBatch {
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

    
    uint256 constant IC0x = 17053846928344350998802493580738087638595330724782781948435593299499494607525;
    uint256 constant IC0y = 11965101847161311578209229394992329677895998609610483438614848062187538581110;
    
    uint256 constant IC1x = 1416194646929535355694961892995828689863356211965628527713606059894446238038;
    uint256 constant IC1y = 456044554490155452010102389189051360820956479208305795526734941401238411466;
    
    uint256 constant IC2x = 8087066964925552101460451401729574162674687512622755070888846220371572721704;
    uint256 constant IC2y = 15516298309359181754580176158703498279338476003035208475645654315864718870185;
    
    uint256 constant IC3x = 14221226657510344054981374137585092978226039660356979765704049882963729283380;
    uint256 constant IC3y = 10826686834380743127420058120136775573660372530261114276689337190657020313482;
    
    uint256 constant IC4x = 14439720623476024065768519458429320832855317504582578222039304640840634004987;
    uint256 constant IC4y = 2506469716311245496110064301350397589647219280839456013860637025786218716281;
    
    uint256 constant IC5x = 2964373650465844939517216113136466716939318358858344677893008536857129305097;
    uint256 constant IC5y = 13686558959063950222463718507188705519344855739984468357073269562983130305536;
    
    uint256 constant IC6x = 6285332050840516953606369049058563419719888604452221160574092159448223154749;
    uint256 constant IC6y = 7324544316662822664953692845820960361177945724006937850477874814951454665939;
    
    uint256 constant IC7x = 10973328992454293464881854246539676769078232367342610017014599255215513204427;
    uint256 constant IC7y = 2637623550748559276689766007212456337881393074082218754280977251337573372493;
    
    uint256 constant IC8x = 12545399138035900164985864294759207402086474720904151642580607935367772170956;
    uint256 constant IC8y = 14825351401529746245331316381645932327893986450085684914372926733548796504544;
    
    uint256 constant IC9x = 10825637261529123822006395152254800939166390443991243847598467737093888038475;
    uint256 constant IC9y = 13925843112575707179357038463822315968135818477725919048257517656905830231940;
    
    uint256 constant IC10x = 10709399669843897804820408705872200687229687444941121043068093969751437714239;
    uint256 constant IC10y = 12945565768336613640250021946893568789525339792326281028287433582934267853691;
    
    uint256 constant IC11x = 15478768072736778467135646669659753456805133374812265361207351070980706340384;
    uint256 constant IC11y = 757839902315670936992660121748072013381281184371933739957693841120676378002;
    
    uint256 constant IC12x = 4554328073414005090653798625419395616893283931820566192326003016260571360052;
    uint256 constant IC12y = 1189389969203651564424575651852817126244952250829977490103548995493474299068;
    
    uint256 constant IC13x = 335829615964528144092757207789952008304371933206676563321102340898251319007;
    uint256 constant IC13y = 7731623954002786012215407813203682032586372955885834065664656306132436365997;
    
    uint256 constant IC14x = 6091392840361353734767778321454651042379507055073555682363886625925248203953;
    uint256 constant IC14y = 19306885946682325940783901113266304521196152351265261204343763298239638114306;
    
    uint256 constant IC15x = 11783656308232177277179388577866161511078872590959241741029409831643637632222;
    uint256 constant IC15y = 12526532078490070951167473821139535551490355136135051918688670323190956618291;
    
    uint256 constant IC16x = 6774458908312308966332504282524318745453711933969918461887753636628499023808;
    uint256 constant IC16y = 5910580788766187271180059836424966363377676141947616160646236766473269226599;
    
    uint256 constant IC17x = 10567369672791205263003124170963246864801473350246391064941849014254786273735;
    uint256 constant IC17y = 8525774187896720446713518183468602490041224033557699960779335634243943211110;
    
    uint256 constant IC18x = 13736933573651228496910079418144261258524074264645273086746502671564881732932;
    uint256 constant IC18y = 17907482215882844837274299573884025729157175374684311033592383852522475284068;
    
    uint256 constant IC19x = 503946258479389959434810413589495651112746495188788310664557844970060278337;
    uint256 constant IC19y = 4952976642403343892721288326300163714557818354830166037263932519311901177528;
    
    uint256 constant IC20x = 14246884670603723776095340731061770886790480641143757738376275175974985675095;
    uint256 constant IC20y = 16825920812472170640525350082442236220755804552262442967471744311463529021677;
    
    uint256 constant IC21x = 9378993931629170226110616467888292821413775486786627591375263726877920778415;
    uint256 constant IC21y = 10528494380808624817716159611589774734053547246328184472636315616238844751256;
    
    uint256 constant IC22x = 369944225205660230371070237824000305195967672557528897141063187618337453388;
    uint256 constant IC22y = 2781037153273060303563709335004469748385856874214113367257213722048722844628;
    
    uint256 constant IC23x = 563165185017277156586914590989610211146612393394745209502606921694411856770;
    uint256 constant IC23y = 1867875812539555179907306772686570618330295637834892371784793120325713160308;
    
    uint256 constant IC24x = 2457096394813884379686442634915495944375990912063278685286306284881036618033;
    uint256 constant IC24y = 9163446075990301051551079616945375045779417347203761606827124976128976017243;
    
    uint256 constant IC25x = 1743053317079366204996691475159512425883170811470216460647956533442828289763;
    uint256 constant IC25y = 13254806637989102281499220587994341892561856643160499096505399992507218188460;
    
    uint256 constant IC26x = 16457212763218512312029045980523021761185322886557104838380955364015299672621;
    uint256 constant IC26y = 3832051276327423572157341674930404819154207918912893988830189275467754156986;
    
    uint256 constant IC27x = 7066732793908631280585447768356572301661729178014215382425422621835198374934;
    uint256 constant IC27y = 20218049939976959412181995154352699629848842510077825918186645655758322949799;
    
    uint256 constant IC28x = 4956541933446787921484019161677028281341025665070293104310847504459808951902;
    uint256 constant IC28y = 3816612363672807131901364108187968999531661471090783307990812661940962728793;
    
    uint256 constant IC29x = 12864855763711014018937686464445079603876150271834557785727424395080640977375;
    uint256 constant IC29y = 17104460204202358952944264943384418106769657136663495962076435904655878943387;
    
    uint256 constant IC30x = 10733803698951847038628465307457406214043524434609329980970498315685711899399;
    uint256 constant IC30y = 16519409387955418716360723471116718454664493931458001942270816646266520269796;
    
    uint256 constant IC31x = 12909939941499886901966667410136137868262843958894123925049005285184892169544;
    uint256 constant IC31y = 1657402006410764881494628061552028843566153692545264489012332399729234496519;
    
    uint256 constant IC32x = 8775036978498508283490314935930852866490644815685499362701526620312348354401;
    uint256 constant IC32y = 19174451949836506203826461224948126006167386246436763884712123287530052126146;
    
    uint256 constant IC33x = 8247659400198328520625339530571568202176233065620852483501423510365143209162;
    uint256 constant IC33y = 12647517307362942578728139692382728564506863665352890035710170306742329147081;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[33] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
