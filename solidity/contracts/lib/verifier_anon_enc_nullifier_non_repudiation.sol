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

    
    uint256 constant IC0x = 13357693122907037228152017576645355734121761212845151058677661103609163192132;
    uint256 constant IC0y = 13330988885278369125767434338537639082919338469462771561109770926455996769780;
    
    uint256 constant IC1x = 12508620784608380390196070593153977553849768584303191369350347694786774228903;
    uint256 constant IC1y = 10497463660231940953738699560093225567814393547271993966494372800288076113838;
    
    uint256 constant IC2x = 13358213132064408118763369803680465216756629096152358454643353054476790534;
    uint256 constant IC2y = 9790361827332836718478767131585804431439300890195490311537005578986541483010;
    
    uint256 constant IC3x = 11263096887435970836664030639381921541149000469179795739631740020273500583762;
    uint256 constant IC3y = 18832878831913866337749700133052402021364972422929250752553120232017053832188;
    
    uint256 constant IC4x = 8650173660622548339501740890775948467326563125469871933001838882801234078865;
    uint256 constant IC4y = 10759885712046409911388806010481069590886057315469905475498658179072397221074;
    
    uint256 constant IC5x = 3295412410302077166334358912280077543044124527280728553051328605050569416328;
    uint256 constant IC5y = 17049453399693780313254529273986739520322108517619709180649214354472986470570;
    
    uint256 constant IC6x = 12760717566528938207556281409639493742824102965038241868422088472886397881705;
    uint256 constant IC6y = 5727694270117362054335093381846045971004329934011468049227701728188501414293;
    
    uint256 constant IC7x = 12723277170340368996181883999061862932296128028814086233379699010714790157803;
    uint256 constant IC7y = 15607664248618872066986748206455003464688091118493663837165373679303271618020;
    
    uint256 constant IC8x = 16064173409510828580097158127999109660877176304290893887184870102987627587345;
    uint256 constant IC8y = 7271726669102543421625318962122042361029332639092998786351706825402022983149;
    
    uint256 constant IC9x = 17868773711481907952191801046128922109639466718556606579429717630927232401150;
    uint256 constant IC9y = 13426021423653145781149475638806424172443891179898547974414561873835013472273;
    
    uint256 constant IC10x = 17231713394258993279280128626680971151901806250026905329830445951311024978649;
    uint256 constant IC10y = 16362220893399236364987780855448702890941734166928744916454228037419247631859;
    
    uint256 constant IC11x = 16393437699418494278442854388319612745568802642878330160854040391387533400112;
    uint256 constant IC11y = 13190069452272446793436396301020962811004079465757898954271497706698165528700;
    
    uint256 constant IC12x = 7378753764477002577496984973794709537014547695465562205837932080193227331968;
    uint256 constant IC12y = 14590455657777965484775453020094930760042823323462890204601760753586004282684;
    
    uint256 constant IC13x = 7997905266075296348375184091609158476322609729212752317911559367095944799223;
    uint256 constant IC13y = 5745139122382514585485874184483029362402802135720894805094527346018931663747;
    
    uint256 constant IC14x = 20169661212830681667121989012648338854355631560185391751223605196103160164011;
    uint256 constant IC14y = 539780066201272709523495794614709990166877660139080643626983915026896119607;
    
    uint256 constant IC15x = 8444655896238788895878628117268993903133580378477751962708257842437863740785;
    uint256 constant IC15y = 14733855077207271591160962228017111069029157259271107029728347242748253125366;
    
    uint256 constant IC16x = 6776365740560628275599288528214364007667844204832291628305205207440991363958;
    uint256 constant IC16y = 10701762678011603715205160753666433247040031283169837460596997733566638035138;
    
    uint256 constant IC17x = 20686935058199339354516949529825885235552968174904347091970372091458356050418;
    uint256 constant IC17y = 2353883119734839433183501301793327525159037748688825810403810896910943236417;
    
    uint256 constant IC18x = 10350893931145787572953344205303374116068374532338249687895170827700639749336;
    uint256 constant IC18y = 14640813458603050243659774385299057516762787203076107453683687533882345081521;
    
    uint256 constant IC19x = 19262254897475671623941666812023122929903981731944691423683488712448697081937;
    uint256 constant IC19y = 18281492578904896322558724606234848271289139471406835707367843671116366444087;
    
    uint256 constant IC20x = 124678580367106714324365512313981313186367450591290500393061028606175892723;
    uint256 constant IC20y = 19622459168604563104848042405466516563770600657501108965523163775411098672757;
    
    uint256 constant IC21x = 7958205631716894096124215035454651749998590123970961934398635953991688058318;
    uint256 constant IC21y = 16567031668980761134299018248953094686118944235178042185849152200978184065876;
    
    uint256 constant IC22x = 7147067657100593571638515910794468040722620253353965676612345848072450126796;
    uint256 constant IC22y = 8323724847034448554879418517026785309068712740584276122197233489445879426431;
    
    uint256 constant IC23x = 4475661955736946565036382810587106183520552266697138427686452731078117767736;
    uint256 constant IC23y = 748082566430464216825026197955511509465126173616326433623980484101730257065;
    
    uint256 constant IC24x = 18871094629535557959761172513178206026645275580390985276286511649250238153689;
    uint256 constant IC24y = 3733404107218228733942648054164246626605647007073122795923180610554195384488;
    
    uint256 constant IC25x = 2384341917215847801652641900530474605831147046585978262725620402385796765901;
    uint256 constant IC25y = 1287779897102903993979483791221014755426631277038764827254149422137772335222;
    
    uint256 constant IC26x = 15719716565017700920545871521869872133915063489073625817617400592054712067072;
    uint256 constant IC26y = 17002113594755025448330507151173960578194214614717460071129326081566116414394;
    
    uint256 constant IC27x = 6069617218858857906572692060956455933260615226814802013802199283144993419830;
    uint256 constant IC27y = 14473506832002574954490482003760587485980065730322794298209159874969554193911;
    
    uint256 constant IC28x = 2095872993541208595971848766255089085389698239862455369992367968040560542101;
    uint256 constant IC28y = 4401957738071377442795776346853489896120525690607490420740185454723130517217;
    
    uint256 constant IC29x = 7948782644008604365957640378662878722460387841213619643734690098279143596558;
    uint256 constant IC29y = 14151027007218971202754362938797936052279026613643428871705306564386243582804;
    
    uint256 constant IC30x = 16055935718830733652525145369258352251162204565999270815122069851184919247791;
    uint256 constant IC30y = 19977921078618552717906884259146829610529552736713600023585181237533888275450;
    
    uint256 constant IC31x = 1724644122707053931125669268159636051378467183669651442417045949735792435846;
    uint256 constant IC31y = 3780427308194609121900455938646860005350278871116671233301051665551523150347;
    
    uint256 constant IC32x = 8043820203766420431969217152893413732635117572573736920587519044322309584347;
    uint256 constant IC32y = 7641739641928705768386491515124236050049577395892226047572150942224894388223;
    
    uint256 constant IC33x = 1212239584949006580410344651147309255656379781955714183101293673886799379224;
    uint256 constant IC33y = 7277339251039550149206299004468645563322367249804601268562416695922597671900;
    
 
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
            
            checkField(calldataload(add(_pubSignals, 1056)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
