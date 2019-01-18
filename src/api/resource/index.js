import { Router } from 'express'
import { token } from '../../services/passport'
import { getAll } from './controller'
import model from './model'

const router = new Router()

export const Resource = model

/**
 * @api {get} /resources Retrieve org's resources
 * @apiName GetResources
 * @apiGroup Resource
 * @apiPermission user
 * @apiSuccess {Object[]} resources List of resources.
 * @apiError {Object} 400 Some parameters may contain invalid values.
 */
router.get('/',
  token({ required: true }),
  getAll
)

export default router
