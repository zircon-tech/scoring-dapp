import { success, notFound } from '../../services/response/'
import { Organization } from '.'

export const update = async ({ params, bodymen: { body: { organizationName } } }, res, next) => {
  try {
    let organization = await Organization.findById(params.id)
    if (!organization) {
      return notFound(res)
    }
    organization = await Object.assign(organization, {
      organizationName
    }).save()

    return success(res, 201)(organization.view())
  } catch (err) {
    next(err)
  }
}
