# scoring-dapp v1.0.0



- [Auth](#auth)
	- [Authenticate](#authenticate)
	
- [Organization](#organization)
	- [Create organization account](#create-organization-account)
	- [Update Organization](#update-organization)
	
- [Resource](#resource)
	- [Retrieve org&#39;s resources](#retrieve-org&#39;s-resources)
	
- [Scorer](#scorer)
	- [Create organization account](#create-organization-account)
	
- [User](#user)
	- [Retrieve org&#39;s scorers](#retrieve-org&#39;s-scorers)
	- [Invite scorer](#invite-scorer)
	- [Retrieve current user](#retrieve-current-user)
	- [Retrieve user](#retrieve-user)
	- [Update myself](#update-myself)
	


# Auth

## Authenticate



	POST /auth

### Headers

| Name    | Type      | Description                          |
|---------|-----------|--------------------------------------|
| Authorization			| String			|  <p>Basic authorization with email and password.</p>							|

# Organization

## Create organization account



	POST /auth/organization/signup


### Parameters

| Name    | Type      | Description                          |
|---------|-----------|--------------------------------------|
| email			| String			|  <p>User's email.</p>							|
| password			| String			|  <p>User's password.</p>							|
| fullName			| String			| **optional** <p>User's name.</p>							|
| organizationName			| String			| **optional** <p>Org name.</p>							|

## Update Organization



	PUT /organizations/:id


### Parameters

| Name    | Type      | Description                          |
|---------|-----------|--------------------------------------|
| access_token			| String			|  <p>user access_token.</p>							|
| id			| String			| **optional** <p>Org's id.</p>							|

# Resource

## Retrieve org&#39;s resources



	GET /resources


# Scorer

## Create organization account



	POST /auth/organization/signup


### Parameters

| Name    | Type      | Description                          |
|---------|-----------|--------------------------------------|
| password			| String			|  <p>User's password.</p>							|
| fullName			| String			| **optional** <p>User's name.</p>							|

# User

## Retrieve org&#39;s scorers



	GET /users/scorers


### Parameters

| Name    | Type      | Description                          |
|---------|-----------|--------------------------------------|
| q			| String			| **optional** <p>Query to search.</p>							|
| page			| Number			| **optional** <p>Page number.</p>							|
| limit			| Number			| **optional** <p>Amount of returned items.</p>							|
| sort			| String[]			| **optional** <p>Order of returned items.</p>							|
| fields			| String[]			| **optional** <p>Fields to be returned.</p>							|

## Invite scorer



	POST /users/scorers/invite


### Parameters

| Name    | Type      | Description                          |
|---------|-----------|--------------------------------------|
| email			| String			|  <p>Scorer's email.</p>							|

## Retrieve current user



	GET /users/me


## Retrieve user



	GET /users/:id


## Update myself



	PUT /users/:id


### Parameters

| Name    | Type      | Description                          |
|---------|-----------|--------------------------------------|
| access_token			| String			|  <p>User access_token.</p>							|


