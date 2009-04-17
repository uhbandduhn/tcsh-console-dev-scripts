<?php
	/*
	 * (c) 2007-Present Kathryn G. Bohmont <uberChicGeekChick.Com -at- uberChicGeekChick.Com>
	 * 	http://uberChicGeekChick.Com/
	 * Writen by an uberChick, other uberChicks please meet me & others @:
	 * 	http://uberChicks.Net/
	 *I'm also disabled; living with Generalized Dystonia.
	 * Specifically: DYT1+/Early-Onset Generalized Dystonia.
	 * 	http://Dystonia-DREAMS.Org/
	 */

	/*
	 * Unless explicitly acquired and licensed from Licensor under another
	 * license, the contents of this file are subject to the Reciprocal Public
	 * License ("RPL") Version 1.5, or subsequent versions as allowed by the RPL,
	 * and You may not copy or use this file in either source code or executable
	 * form, except in compliance with the terms and conditions of the RPL.
	 *
	 * All software distributed under the RPL is provided strictly on an "AS
	 * IS" basis, WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, AND
	 * LICENSOR HEREBY DISCLAIMS ALL SUCH WARRANTIES, INCLUDING WITHOUT
	 * LIMITATION, ANY WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
	 * PURPOSE, QUIET ENJOYMENT, OR NON-INFRINGEMENT. See the RPL for specific
	 * language governing rights and limitations under the RPL.
	 *
	 * ---------------------------------------------------------------------------------
	 * |	A copy of the RPL 1.5 may be found with this project or online at	|
	 * |		http://opensource.org/licenses/rpl1.5.txt					|
	 * ---------------------------------------------------------------------------------
	 */
	
	/*
	 * ALWAYS PROGRAM FOR ENJOYMENT &PLEASURE!!!
	 * Feel comfortable takeing baby steps.  Every moment is another step; step by step; there are only baby steps.
	 * Being verbose in comments, variables, functions, methods, &anything else IS GOOD!
	 * If I forget ANY OF THIS than READ:
	 * 	"Paul Graham's: Hackers &Painters"
	 * 	&& ||
	 * 	"The Mentor's Last Words: The Hackers Manifesto"
	 */

	return array(
		array(
			array( '/\&(#038|amp);/i', '\&' ),
			array( '/\&(#8243|#8217|#8220|#8221|#039|rsquo|lsquo);/i', '\'' ),
			array( '/[\ \t]*&[^;]+;[\ \t]*/i', '' ),
			array( '/<\!\[CDATA\[(.*)\]\]>/', '$1' ),
			'total'=>4,
		),
		array(
			array( '/(Zero)/i', '0'),
			array( '/(One)/i', '1'),
			array( '/(Two)/i', '2'),
			array( '/(Three)/i', '3'),
			array( '/(Four)/i', '4'),
			array( '/(Five)/i', '5'),
			array( '/(Six)/i', '6'),
			array( '/(Seven)/i', '7'),
			array( '/(Eight)/i', '8'),
			array( '/(Nine)/i', '9'),
			array( '/(Ten)/i', '10'),
			array( '/(Ten)/i', '10'),
			array( '/(Eleven)/i', '11'),
			array( '/(Twelve)/i', '12'),
			array( '/(Thirteen)/i', '13'),
			array( '/(Fifteen)/i', '15'),
			array( '/([0-9])teen/i', '1$1'),
			array( '/(Twenty)/i', '20'),
			array( '/(Thirty)/i', '30'),
			array( '/(Fifty)/i', '50'),
			array( '/([0-9])ty/i', '$10'),
			'total'=>21,
		),
		array(
			array( '/^([0-9])([^0-9])/i', '0$1$2'),
			array( '/([^0-9])([0-9])([^0-9])/i', '$10$2$3'),
			array( '/([^0-9])([0-9])$/i', '$10$2'),
			'total'=>3,
		),
		'total'=>3,
	);

?>