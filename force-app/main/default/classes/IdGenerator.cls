@isTest
public with sharing class IdGenerator
{
	private static Integer idCount = 0;
	private static final String ID_PATTERN = '000000000000';

	/**
	 * Generate a fake Salesforce Id for the given SObjectType
	 */
	public static Id generate(Schema.SObjectType sobjectType)
	{
		String keyPrefix = sobjectType.getDescribe().getKeyPrefix();
		idCount ++;

		String fakeIdPrefix = ID_PATTERN.substring(0, 12 - idCount.format().length());

		return Id.valueOf(keyPrefix + fakeIdPrefix + idCount);
	}
}