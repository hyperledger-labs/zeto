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

    
    uint256 constant IC0x = 20853042574020946235840302632951626448584729217430463073658625252653442234470;
    uint256 constant IC0y = 14503138457722137782191667133387775512378441450608154667415400997876588375756;
    
    uint256 constant IC1x = 9917108883241745455761018857293725080986600904966561402987858446669928171562;
    uint256 constant IC1y = 13591576404881350424099489953236979715833180126901849937308367347767610003465;
    
    uint256 constant IC2x = 3439313319113787828822932825613902061625901916953552729570520107357795750003;
    uint256 constant IC2y = 9071769450731382460996101819929952295744188293777029244789694675101186914880;
    
    uint256 constant IC3x = 11071390041396097409656810177854839065668652917492828205135215218787046170986;
    uint256 constant IC3y = 3272310063044466086764292869007916039227746382830358278319476052921781064725;
    
    uint256 constant IC4x = 996881781996032055965059788092723706548950481104118223959532856028689400891;
    uint256 constant IC4y = 10532644959511591332308661306141830757428321012840862531511843489701188531007;
    
    uint256 constant IC5x = 16385079024538141632411180902174351098878184968791691093347655199291480888415;
    uint256 constant IC5y = 12145168420230320464303312360648053440022739646635064174869624146870557981618;
    
    uint256 constant IC6x = 3992613102026963086376267251279994644621145284197309267871587996886604272592;
    uint256 constant IC6y = 14963328476320115013495064157131701351415433169672444967080683342149793144980;
    
    uint256 constant IC7x = 5981370305969014820267670759122547893731675070596036612273472072253851282228;
    uint256 constant IC7y = 3438141511037073702365606004410722567958864390457606755249640661003617200959;
    
    uint256 constant IC8x = 21547361705076824058864897700975767421445572004417178472869801085917191751053;
    uint256 constant IC8y = 12999813802284380841701554591228638984354832042714692917690348439711845925786;
    
    uint256 constant IC9x = 14925705040521825434725348380587205868708787466106833983126208243739784325880;
    uint256 constant IC9y = 13758617988846944266119557597035763290845707283246935944438721816538364307440;
    
    uint256 constant IC10x = 16238678108997178508219583626087543367523363104143821500531018331128543816027;
    uint256 constant IC10y = 20988334055882823813676265253003773967912918491946607153880822125279265295099;
    
    uint256 constant IC11x = 12463438669969160987739884097285949261976866404968861676769237436058385801469;
    uint256 constant IC11y = 270011245713606791865522697127318460224244162144440036914608059839284140679;
    
    uint256 constant IC12x = 14425667004891942326901126602922354917481325657272065431210263120371031139386;
    uint256 constant IC12y = 8309982229703456513092026779649997434002091050319895182314276093188954677394;
    
    uint256 constant IC13x = 7465033032486596700975998529561351608432568332029212554720368237664678873395;
    uint256 constant IC13y = 19595443713093539422546405240457003346980791492404739217874241019739472718381;
    
    uint256 constant IC14x = 14691687249031531163869527355048787597122549812332779621162154509937138571924;
    uint256 constant IC14y = 17802893028884323977106339050154399655146360203535885909201781361795599138777;
    
    uint256 constant IC15x = 11311460953090916038412938363173223681102634415830351013156281568159118324573;
    uint256 constant IC15y = 989424361042903697721304390768895807648689453596077746086797179149951408171;
    
    uint256 constant IC16x = 8115210135502535315095755231549369443363739326778462555855100709757443031875;
    uint256 constant IC16y = 3399309059585388188749745821681321969923494328608462736591564694635156883018;
    
    uint256 constant IC17x = 8057525237113913042507983000939528960621623812954743702785235804447181483476;
    uint256 constant IC17y = 11745508255799538715267264369198317129411105677293807565792222040292163514690;
    
    uint256 constant IC18x = 12882807096622945037046242519935093674601153177531384614838357303812929546434;
    uint256 constant IC18y = 14167183722748533864284151708151235074065479637878014422305168060669442759124;
    
    uint256 constant IC19x = 19157711982679260432612324639548309993214116386141443298649333176424963278008;
    uint256 constant IC19y = 18887459881212198278163366740593313984610163871911225805583022177205802284106;
    
    uint256 constant IC20x = 6820016076303366905281218333771319642092009820489375329286304918390680797076;
    uint256 constant IC20y = 2011003244794874591620399658770025487624841238441008369549360919209162431452;
    
    uint256 constant IC21x = 11041858300928368147282501090696352446503267451042743846924625524700949589333;
    uint256 constant IC21y = 18326112349200889304757099732521649558736758992759435858884556656373804632540;
    
    uint256 constant IC22x = 19270053956090024762685183355862847807940837944222186876532100272229966284063;
    uint256 constant IC22y = 6755707463932868859120703481720189322239061262061342349595686619636209076032;
    
    uint256 constant IC23x = 14053076389630026405095058736457484143951784177074765146291105887519279239631;
    uint256 constant IC23y = 5781535215165614826618204367105163909125962009938863102327081807253219564177;
    
    uint256 constant IC24x = 16520121922742730700115206847425977584572662211415479692333894716807168534635;
    uint256 constant IC24y = 1097596215960000784908553058258153084091625215200170506677504975817144320377;
    
    uint256 constant IC25x = 7177925932485708100888950060980021914147468071168635995447299902061247390967;
    uint256 constant IC25y = 10219836500844667480405804775499348980007485977518659417779754787366552657126;
    
    uint256 constant IC26x = 3501572605055564424981383194400900888063129293811612920810221741230443016407;
    uint256 constant IC26y = 16388010556608225219508510331953863848059248100921826015425452033600132558501;
    
    uint256 constant IC27x = 821629801785990279612662785124699542694089690212215734187557850876770421856;
    uint256 constant IC27y = 19080762213042567735389244764183591911677853260112860780943095910556531204198;
    
    uint256 constant IC28x = 16852281762315476053210814715155070801137202720975023006070913982938627645876;
    uint256 constant IC28y = 7213332702185063988587527288845721443807112228829510340283781784592101934378;
    
    uint256 constant IC29x = 4009657540500682658456131646734110816806134393092673870093501487131176269366;
    uint256 constant IC29y = 4642340153685914773598767712007875167875744207496785942087827910783897016130;
    
    uint256 constant IC30x = 2354097312656732326431256481812991541730435396462756081659188095985189268893;
    uint256 constant IC30y = 5648911243543082544815214546011075680816809894496626503218159000561356166387;
    
    uint256 constant IC31x = 21349175980680327148991838367425372259029351360226383721547593451385165894470;
    uint256 constant IC31y = 2226069768655531699819829432398234311723723757156974454812739012506324533869;
    
    uint256 constant IC32x = 6889212865028125309464348326210571985659646832435844307314388021016016438758;
    uint256 constant IC32y = 3898026925935534773719478862659632823086703925842749427712203456282341722035;
    
 
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
            
            checkField(calldataload(add(_pubSignals, 1024)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
